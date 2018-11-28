defmodule PaddleParsers.MatchPage do
  @moduledoc """
  Responsible for handling a match page in the CPTC website.

  Here is an example of a url: https://myapta.org/node/63655
  """

  @doc """
  This function receives html containing 4 matches.
  We need to return 4 structs with the correct match details
  """
  def parse_match_page(html) do
    match_details =
      html
      |> Floki.find(".field_collection_item")
      |> Enum.map(fn el -> parse_individual_match(el) end)

    date = html |> parse_date()

    {home_club, away_club} = html |> Floki.find(".page-header") |> parse_clubs()

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

    [_, _, _, a, b, _] = String.split(year, "")

    "#{month_lookup[String.to_atom(month)]}-#{String.replace(day, ",", "")}-#{a}#{b}"
  end

  defp parse_clubs(input) do
    [{_, _, [clubs]}] = input

    [home_club, away_club] =
      String.split(clubs, " v ")
      |> Enum.map(fn c ->
        c
        |> remove_bad_club_series()
        |> remove_bad_saddle_name()
      end)

    {home_club, away_club}
  end

  # https://myapta.org/team/584/matches -> has a "-10" in the name, this is the only instance. Crazy.
  defp remove_bad_club_series(club_name) do
    if String.contains?(club_name, "-10") do
      String.replace(club_name, "-10", "- 10")
    else
      club_name
    end
  end

  defp remove_bad_saddle_name(club_name) do
    if String.contains?(club_name, "amp;") do
      String.replace(club_name, "amp;", "")
    else
      club_name
    end
  end

  defp parse_individual_match(input) do
    raw_html = input |> Floki.raw_html()

    %{
      court_number: raw_html |> parse_court_number(),
      home_player_1: raw_html |> parse_player(".field_home_player_1"),
      home_player_2: raw_html |> parse_player(".field_home_player_2"),
      home_scores: raw_html |> parse_sets(".field_home_set_scores"),
      home_outcome: raw_html |> parse_outcome(".field-name-field-home-court-points"),
      away_player_1: raw_html |> parse_player(".field_away_player_1"),
      away_player_2: raw_html |> parse_player(".field_away_player_2"),
      away_scores: raw_html |> parse_sets(".field_away_set_scores"),
      away_outcome: raw_html |> parse_outcome(".field-name-field-away-court-points")
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

  defp parse_court_number(input) do
    [{_, _, [court_number]} | _rest] = input |> Floki.find(".field_collection_item td")
    court_number
  end

  defp parse_player(input, css_class) do
    case Floki.find(input, css_class) do
      [{_, _, [{_, _, [{_, _, [{_, _, [player]}]}]}]}] ->
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
       ]}
    ] = Floki.find(input, css_class)

    "#{first_set},#{second_set},#{third_set}"
  end
end
