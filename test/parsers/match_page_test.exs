defmodule PaddleParsers.MatchPageTest do
  use ExUnit.Case

  describe "parse_match_page/1" do
    def load_file(filename) do
      [File.cwd!(), "test", "static_html", "match_pages", filename]
      |> Path.join()
      |> File.read!()
    end

    test "returns a struct with the correct values - men, simplest case" do
      result = "series_1_m.htm" |> load_file() |> PaddleParsers.parse_match_page()

      expected = %{
        away_club: "Glen Ellyn 6.0(a) - 1",
        home_club: "Hinsdale PD 6.0(a) - 1",
        matches: [
          %{
            away_player_1: "Graham McNerney",
            away_player_2: "Matt Warner",
            away_scores: "7,6,0",
            court_number: "1",
            home_player_1: "Ben Williams",
            home_player_2: "Ryan Mullaney III",
            home_scores: "6,3,0",
            away_outcome: "w",
            home_outcome: "l"
          },
          %{
            away_player_1: "Adam Shaeffer",
            away_player_2: "Mark Cunnington",
            away_scores: "6,7,0",
            court_number: "2",
            home_player_1: "Matthew Kinst",
            home_player_2: "Jeff Byrnes",
            home_scores: "3,5,0",
            away_outcome: "w",
            home_outcome: "l"
          },
          %{
            away_player_1: "Eddie DeLaCruz",
            away_player_2: "Alex Lambropoulos",
            away_scores: "3,5,0",
            court_number: "3",
            home_player_1: "Adam Boyce",
            home_player_2: "Andrew Tomson",
            home_scores: "6,7,0",
            away_outcome: "l",
            home_outcome: "w"
          },
          %{
            away_player_1: "Mackey Pierce",
            away_player_2: "Kevin Howard",
            away_scores: "4,4,0",
            court_number: "4",
            home_player_1: "Mark Schaefer",
            home_player_2: "Reed Schaefer",
            home_scores: "6,6,0",
            away_outcome: "l",
            home_outcome: "w"
          }
        ],
        date: "09-28-17"
      }

      assert result == expected
      assert Enum.at(result.matches, 3).home_scores == "6,6,0"
    end

    test "returns a struct with the correct values - men, weird club name" do
      result = "series_10_m.htm" |> load_file() |> PaddleParsers.parse_match_page()

      expected = %{
        date: "09-28-17",
        away_club: "Lake Bluff 4.5(c) - 10",
        home_club: "Evanston 4.5(c) - 10",
        matches: [
          %{
            away_outcome: "w",
            court_number: "1",
            home_outcome: "l",
            away_player_1: "George Lambropoulos",
            away_player_2: "Zach Carlins",
            away_scores: "0,7,7",
            home_player_1: "Bob Ernst",
            home_player_2: "John Lawrence",
            home_scores: "6,6,5"
          },
          %{
            court_number: "2",
            away_outcome: "l",
            away_player_1: "Don Fawcett",
            away_player_2: "Ken Hite",
            away_scores: "5,6,0",
            home_outcome: "w",
            home_player_1: "Don Wheeler",
            home_player_2: "Pat Mulhern",
            home_scores: "7,7,0"
          },
          %{
            away_outcome: "l",
            court_number: "3",
            home_outcome: "w",
            away_player_1: "Howard Bennett",
            away_player_2: "Will Thoms",
            away_scores: "2,4,0",
            home_player_1: "T.J. Dammrich",
            home_player_2: "Mark Ackerman",
            home_scores: "6,6,0"
          },
          %{
            away_outcome: "l",
            court_number: "4",
            home_outcome: "w",
            away_player_1: "Sean Murphy",
            away_player_2: "Parlin Jessen",
            away_scores: "4,7,4",
            home_player_1: "Andy Weimer",
            home_player_2: "Adam Finkelstein",
            home_scores: "6,5,6"
          }
        ]
      }

      assert result == expected
      assert Enum.at(result.matches, 3).home_scores == "6,5,6"
    end

    test "returns a struct with the correct values - Women, SW, with no results for a given match" do
      result = "series_12_f_sw.htm" |> load_file() |> PaddleParsers.parse_match_page()

      expected = %{
        away_club: "Butterfield (1) SW-XII",
        date: "10-05-17",
        home_club: "Salt Creek SW-XII",
        matches: [
          %{
            away_outcome: "w",
            court_number: "1",
            home_outcome: "l",
            away_player_1: "Trisha  Wilson",
            away_player_2: "Patty Mullins",
            away_scores: "6,7,0",
            home_player_1: "Denise Pacioni",
            home_player_2: "Susan Davis",
            home_scores: "4,6,0"
          },
          %{
            court_number: "2",
            away_outcome: "w",
            away_player_1: "Lara Matracaria",
            away_player_2: "Maria Dussias",
            away_scores: "1,6,6",
            home_outcome: "l",
            home_player_1: "Ann Singer(sub)",
            home_player_2: "Mardi Huffman",
            home_scores: "6,1,1"
          },
          %{
            court_number: "3",
            away_outcome: "w",
            away_player_1: "Laura Alter",
            away_player_2: "Camille Gianatasio",
            away_scores: "6,6,0",
            home_outcome: "l",
            home_player_1: "",
            home_player_2: "Kendall Hewitt",
            home_scores: "3,2,0"
          },
          %{
            court_number: "4",
            away_outcome: "w",
            away_player_1: "",
            away_player_2: "",
            away_scores: "0,0,0",
            home_outcome: "l",
            home_player_1: "",
            home_player_2: "",
            home_scores: "0,0,0"
          }
        ]
      }

      assert result == expected
      assert Enum.at(result.matches, 3).home_scores == "0,0,0"
    end

    test "returns a struct with the correct values - Women, s1" do
      result = "series_1_f.htm" |> load_file() |> PaddleParsers.parse_match_page()

      expected = %{
        away_club: "Hinsdale PD I",
        date: "02-01-18",
        home_club: "Prairie Club I",
        matches: [
          %{
            court_number: "1",
            away_outcome: "l",
            away_player_1: "Mary Doten",
            away_player_2: "Shawna Zsinko",
            away_scores: "0,6,4",
            home_outcome: "w",
            home_player_1: "Kelly Rohrbach",
            home_player_2: "Marina Ohlmuller",
            home_scores: "6,1,6"
          },
          %{
            away_outcome: "w",
            court_number: "2",
            home_outcome: "l",
            away_player_1: "Holly Tritt",
            away_player_2: "Alice Waverley",
            away_scores: "7,3,6",
            home_player_1: "Shannon Vinson",
            home_player_2: "Mindee Epstein",
            home_scores: "5,6,3"
          },
          %{
            away_outcome: "w",
            away_scores: "6,6,0",
            court_number: "3",
            home_outcome: "l",
            away_player_1: "Stephanie Turner",
            away_player_2: "Courtney Hughes",
            home_player_1: "Lisa Goldberg",
            home_player_2: "Laird Kelsey",
            home_scores: "1,1,0"
          },
          %{
            away_outcome: "w",
            court_number: "4",
            home_outcome: "l",
            away_player_1: "Chris O'Malley",
            away_player_2: "Gwen Pontikes",
            away_scores: "6,6,0",
            home_player_1: "Sean Potter",
            home_player_2: "Kathryn Gilbertson",
            home_scores: "1,1,0"
          }
        ]
      }

      assert result == expected
      assert Enum.at(result.matches, 3).home_scores == "1,1,0"
    end

    test "returns a struct with the correct values - Men series 10, saddle and cycle issue" do
      result = "series_10_m_saddle_edge_case.htm" |> load_file() |> PaddleParsers.parse_match_page()

      expected = %{
        away_club: "Saddle & Cycle 4.5(c) - 10",
        date: "09-28-17",
        home_club: "River Forest 4.5(c) - 10",
        matches: [
          %{
            away_outcome: "l",
            court_number: "1",
            home_outcome: "w",
            away_player_1: "Raj Garapati",
            away_player_2: "Graham Gerst",
            away_scores: "4,1,0",
            home_player_1: "Dave Willsey",
            home_player_2: "Kevin Sarsany",
            home_scores: "6,6,0"
          },
          %{
            away_outcome: "w",
            court_number: "2",
            home_outcome: "l",
            away_player_1: "Francis Freeman",
            away_player_2: "Paul Wiggin",
            away_scores: "3,6,6",
            home_player_1: "Charles Boyd",
            home_player_2: "Rich Hoffman",
            home_scores: "6,4,4"
          },
          %{
            court_number: "3",
            away_outcome: "l",
            away_player_1: "JC Lapiere",
            away_player_2: "Doug Leik",
            away_scores: "2,5,0",
            home_outcome: "w",
            home_player_1: "John Sullivan",
            home_player_2: "Ray Berens",
            home_scores: "6,7,0"
          },
          %{
            away_outcome: "w",
            court_number: "4",
            home_outcome: "l",
            away_player_1: "James Morro",
            away_player_2: "Keith Olsen",
            away_scores: "7,3,6",
            home_player_1: "Tony Ashley",
            home_player_2: "Mark Vincent",
            home_scores: "5,6,4"
          }
        ]
      }

      assert result == expected
      assert Enum.at(result.matches, 3).home_scores == "5,6,4"
    end

    @tag :new_website_design
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
