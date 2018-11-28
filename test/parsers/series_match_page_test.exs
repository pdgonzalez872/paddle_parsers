defmodule PaddleParsers.SeriesMatchPageTest do
  use ExUnit.Case

  describe "parse_series_matches_page/1" do
    test "returns a list with the match urls for that series" do
      result =
        [File.cwd!(), "test", "static_html", "series_match_pages", "series_1_m.htm"]
        |> Path.join()
        |> File.read!()
        |> PaddleParsers.parse_series_matches_page()

      %{series_number: series_number, match_list: match_list} = result

      assert series_number == 1
      assert Enum.member?(match_list, "/node/63567") == true
      assert Enum.member?(match_list, "/node/63655") == true
      assert Enum.all?(match_list, fn el -> !is_nil(el) end) == true
    end
  end

  @tag :new_website_design
  describe "parse_series_matches_page/1 - new_website_design" do
    test "returns a list with the match urls for that series - new_website_design" do
      result =
        [
          File.cwd!(),
          "test",
          "static_html",
          "series_match_pages",
          "series_1_m_20181028_design.html"
        ]
        |> Path.join()
        |> File.read!()
        |> PaddleParsers.parse_series_matches_page()

      %{series_number: series_number, match_list: match_list} = result

      assert series_number == 1
      assert Enum.member?(match_list, "/node/79205") == true
      assert Enum.all?(match_list, fn el -> !is_nil(el) end) == true
    end
  end

  describe "extract_series_number_and_gender_from_header/1" do
    test "returns the correct series number, default s1" do
      {series, gender} =
        "6.0(a) - 1"
        |> PaddleParsers.extract_series_number_and_gender_from_header()

      assert series == 1
      assert gender == "m"
    end

    test "returns the correct series number, sw m 20" do
      {series, gender} =
        "4.0 - 20 SW"
        |> PaddleParsers.extract_series_number_and_gender_from_header()

      assert series == 20
      assert gender == "m"
    end

    test "returns the correct series number, default women IV" do
      {series, gender} =
        "IV"
        |> PaddleParsers.extract_series_number_and_gender_from_header()

      assert series == 4
      assert gender == "f"
    end

    test "returns the correct series number, sw 12 women - SOUTHWEST XII" do
      {series, gender} =
        "SOUTHWEST XII"
        |> PaddleParsers.extract_series_number_and_gender_from_header()

      assert series == 12
      assert gender == "f"
    end
  end
end
