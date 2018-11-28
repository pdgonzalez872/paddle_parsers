defmodule PaddleParsers do
  alias PaddleParsers.{MatchPage, SeriesMatchPage}

  def parse_match_page(input) do
    input
    |> MatchPage.parse_match_page()
  end

  def parse_series_matches_page(input) do
    input
    |> SeriesMatchPage.parse_series_matches_page()
  end

  @roman_numeral_lookup %{
    "I" => 1,
    "II" => 2,
    "III" => 3,
    "IV" => 4,
    "V" => 5,
    "VI" => 6,
    "VII" => 7,
    "VIII" => 8,
    "IX" => 9,
    "X" => 10,
    "XI" => 11,
    "XII" => 12,
    "XIII" => 13,
    "XIV" => 14,
    "XV" => 15,
    "XVI" => 16,
    "XVII" => 17,
    "XVIII" => 18,
    "XIX" => 19,
    "XX" => 20
  }

  def roman_numeral_lookup() do
    @roman_numeral_lookup
  end

  def extract_series_number_and_gender_from_header(input) do
    input
    |> SeriesMatchPage.extract_series_number_and_gender_from_header()
  end
end
