#!/usr/bin/env elixir

defmodule F do
  @output_file "autoload/tailwind/data.vim"
  @url 'https://unpkg.com/tailwindcss@1.4.6/dist/tailwind.css'

  def clean_class(class) do
    class
    |> (fn class ->
      if String.match?(class, ~r/[\da-z]:/) do
        result = Regex.scan(~r/\w\:/, class, return: :index)
        [{cut, _}] = List.last(result)
        String.slice(class, 0, cut + 1)
      else
        class
      end
    end).()
    |> String.replace("\\", "")
    |> String.slice(1, 1000)
  end

  def clean_menu(css) do
    css
    |> String.trim()
    |> String.split(";")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> (fn
      [simple] -> simple

      [head | rest] ->
        if String.at(head, 0) == "-" do
          hd(rest)
        else
          head <> " ..."
        end
    end).()
  end

  def clean_info(info) do
    info
    |> String.replace("\n", "\\n")
    |> String.replace("\"", "\\\"")
  end

  def new(word, menu, info) do
    %{
      word: word,
      menu: menu,
      info: info
    }
  end

  def mapper([full_match, class, css]) do
    new(
      clean_class(class),
      clean_menu(css),
      clean_info(full_match)
    )
  end

  def get_tailwind do
    :inets.start()
    :ssl.start()

    {:ok, {_status, _headers, body}} = :httpc.request(:get, {@url, []}, [], [])

    to_string(body)
  end

  def main do
    input = get_tailwind()
    class_regex = ~r/(\.\w[\w\-\\\:]*) \{(.*?)\}/s

    output = File.open!(@output_file, [:raw, :write])

    :file.write(output, "let s:tailwind_classes = [\n")

    Regex.scan(class_regex, input)
    |> Enum.map(&F.mapper/1)
    |> Enum.uniq_by(&(&1[:word]))
    |> Enum.each(fn class ->
      :file.write(
        output,
        "\\{'word': '#{class[:word]}', 'menu': '#{class[:menu]}', 'info': \"#{class[:info]}\"},\n"
      )
    end)
    :file.write(output, "\\]\n\n")
    :file.write(output, "function! tailwind#data#classes()\n")
    :file.write(output, "  return s:tailwind_classes\n")
    :file.write(output, "endfunction\n")

    File.close(output)
  end
end

F.main()
