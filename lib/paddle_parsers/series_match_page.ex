defmodule PaddleParsers.SeriesMatchPage do

  # remove this when extracting

  @doc """
  Parses the html for a series match page and returns a data structure

  The goal is to end up with a data structure like this:

  %{series_number: 1, match_list: ["/node/68561"]}
  """
  def parse_series_matches_page(html) do
    [{_, _, [page_header]}] = Floki.find(html, "h1.page-header")

    {series_number, gender} = page_header |> extract_series_number_and_gender_from_header()
    match_list = html |> extract_list_of_urls()

    %{series_number: series_number, match_list: match_list, gender: gender}
  end

  @doc """
  Extracts the series number from an input
  """
  def extract_series_number_and_gender_from_header(input) do
    to_normalize =
      case split_input = String.split(input, " ") do
        # Men's SW
        [_, _, series, "SW"] ->
          %{series: series, gender: "m"}

        # Men's default
        [_, _, series] ->
          %{series: series, gender: "m"}

        # Women's SW
        ["SOUTHWEST", series] ->
          %{series: series, gender: "f"}

        # Women's default
        [series] ->
          %{series: series, gender: "f"}

        _ ->
          raise "Need a new clause for #{split_input}"
      end

    n_series = to_normalize.series |> normalize()
    {n_series, to_normalize.gender}
  end

  defp extract_list_of_urls(input) do
    input
    |> Floki.find(".view-content table.views-table tr")
    |> Enum.map(fn el ->
      {_, _, finished} = el

      satisfied =
        finished
        |> Enum.at(-2)
        |> Floki.text()
        |> String.contains?("Finished")

      if satisfied do
        {_, _, [{_, _, [{_, _, [{_, [{"href", url}], _}]}]}]} = Enum.at(finished, -1)
        url
      end
    end)
    |> Enum.filter(fn el -> !is_nil(el) end)
  end

  defp normalize(input) when is_binary(input) do
    case Integer.parse(input) do
      {result, _} ->
        result

      :error ->
        PaddleParsers.roman_numeral_lookup()[input]

      _ ->
        raise "Error with #{input}roman"
    end
  end

  defp normalize(input) do
    raise "This is weird -> #{input}"
  end
end
