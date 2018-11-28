defmodule PaddleParsers.MatchPage do
  @moduledoc """
  Responsible for handling a match page in the CPTC website.

  Here is an example of a url: https://myapta.org/node/63655
  """

  require Logger

  @doc """
  This function receives html containing 4 matches.
  We need to return 4 structs with the correct match details
  """
  def parse_match_page(html) do
    match_details =
      html
      |> Floki.find(".field-collection-item")
      |> Enum.with_index()
      |> Enum.map(fn el -> parse_individual_match(el) end)

    date = html |> parse_date()

    {home_club, away_club} = html |> parse_clubs()

    %{home_club: home_club, away_club: away_club, matches: match_details, date: date}
  end

  defp parse_date(input) do
    [{_, _, [date_string]}] = input |> Floki.find("td.views-field-match-date")
    [_day_w, month, day, year | _rest] = date_string |> String.trim() |> String.split(" ")

    month_lookup = %{
      January: "01",
      February: "02",
      March: "03",
      April: "04",
      May: "05",
      June: "06",
      July: "07",
      August: "08",
      September: "09",
      October: "10",
      November: "11",
      December: "12"
    }

    [_, _, a, b] = String.split(year, "", trim: true)

    "#{month_lookup[String.to_atom(month)]}-#{String.replace(day, ",", "")}-#{a}#{b}"
  end

  defp parse_clubs(input) do
    [
      _,
      {_, _,
       [
         {_, _,
          [
            {_, _,
             [{_, _, [{_, _, [{_, _, [home_club]}, _]}, _, {_, _, [{_, _, [away_club]}, _]}, _]}]}
          ]}
       ]}
    ] = input |> Floki.find(".views-field-match-title")

    {home_club, away_club}
  end

  defp parse_individual_match(input) do
    {rest, court_number_index} = input

    court_number = court_number_index + 1

    raw_html = rest |> Floki.raw_html()

    home_player_1 = raw_html |> parse_player(".field-name-field-home-player-1")
    home_player_2 = raw_html |> parse_player(".field-name-field-home-player-2")
    home_scores = raw_html |> parse_sets(".field-name-field-home-set-scores")
    home_outcome = raw_html |> parse_outcome(".field-name-field-home-court-points")
    away_player_1 = raw_html |> parse_player(".field-name-field-away-player-1")
    away_player_2 = raw_html |> parse_player(".field-name-field-away-player-2")
    away_scores = raw_html |> parse_sets(".field-name-field-away-set-scores")
    away_outcome = raw_html |> parse_outcome(".field-name-field-away-court-points")

    %{
      court_number: "#{court_number}",
      home_player_1: home_player_1,
      home_player_2: home_player_2,
      home_scores: home_scores,
      home_outcome: home_outcome,
      away_player_1: away_player_1,
      away_player_2: away_player_2,
      away_scores: away_scores,
      away_outcome: away_outcome
    }
  end

  defp parse_outcome(input, css_class) do
    [{_, _, [{_, _, [{_, _, [outcome]}]}]}] = Floki.find(input, css_class)

    case outcome do
      "3" ->
        "w"

      _ ->
        "l"
    end
  end

  defp parse_player(input, css_class) do
    case Floki.find(input, css_class) do
      [{_, _, [{_, _, [{_, _, [player]}]}]}] ->
        player

      _ ->
        ""
    end
  end

  defp parse_sets(input, css_class) do
    [
      {_, _,
       [
         {_, _,
          [
            {_, _,
             [
               {_, _,
                [
                  {_, _,
                   [
                     _,
                     {_, _,
                      [
                        {_, _,
                         [_, {_, _, [first_set]}, {_, _, [second_set]}, {_, _, [third_set]}]}
                      ]}
                   ]}
                ]}
             ]}
          ]}
       ]}
    ] = Floki.find(input, css_class)

    "#{first_set},#{second_set},#{third_set}"
  end
end
