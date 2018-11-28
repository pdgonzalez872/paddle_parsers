defmodule PaddleParsers.MatchPageTest do
  use ExUnit.Case

  describe "parse_match_page/1" do
    def load_file(filename) do
      [File.cwd!(), "test", "static_html", "match_pages", filename]
      |> Path.join()
      |> File.read!()
    end

    test "returns a struct with the correct values - Women, SW, with no results for a given match" do
    end

    test "returns a struct with the correct values - Women, s1" do
    end

    test "returns a struct with the correct values - Men series 10, saddle and cycle issue" do
    end

    test "returns a struct with the correct values - men, s1, new website" do
      result = "series_1_m_new_website_design.html" |> load_file() |> PaddleParsers.parse_match_page_latest_design()

      expected = %{
        home_club: "Glen View 6.0(a) - 1",
        away_club: "Hinsdale PD 6.0(a) - 1",
        matches: [
          %{
            away_player_1: "Paulo Gonzalez",
            away_player_2: "Ryan Mullaney III",
            away_scores: "3,1,0",
            court_number: "1",
            home_player_1: "Ben McKnight",
            home_player_2: "Paul Rose",
            home_scores: "6,6,0",
            away_outcome: "l",
            home_outcome: "w"
          },
          %{
            away_player_1: "Ben Williams",
            away_player_2: "Jeff Byrnes",
            away_scores: "7,6,0",
            court_number: "2",
            home_player_1: "Jason Love",
            home_player_2: "Tom Rowland",
            home_scores: "6,4,0",
            away_outcome: "w",
            home_outcome: "l"
          },
          %{
            away_player_1: "Matthew Kinst",
            away_player_2: "Adam Boyce",
            away_scores: "3,6,7",
            court_number: "3",
            home_player_1: "Doug Rowe",
            home_player_2: "Michael Brual",
            home_scores: "6,1,6",
            away_outcome: "w",
            home_outcome: "l"
          },
          %{
            away_player_1: "Mark Schaefer",
            away_player_2: "Eric Kozlowski",
            away_scores: "4,6,6",
            court_number: "4",
            home_player_1: "Dave Polayes",
            home_player_2: "David Williams",
            home_scores: "6,4,4",
            away_outcome: "w",
            home_outcome: "l"
          }
        ],
        date: "10-05-17"
      }

      assert result == expected
    end
  end
end
