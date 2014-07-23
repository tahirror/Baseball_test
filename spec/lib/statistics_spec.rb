require 'spec_helper'
#require_relative '../../lib/baseball_statistics/statistics'
require_relative '../../config/configuration'

module Baseball
    describe Statistics do
      before(:all) do
        player_config = Configuration.for 'player_input_file'
        player_file_path = File.expand_path(player_config.input_file_name)
        batting_config = Configuration.for 'batting_input_file'
        batting_file_path = File.expand_path(batting_config.input_file_name)
        data_loader = LoadData.new
        @player = data_loader.load_player_data(player_file_path)
        data_loader = LoadData.new
        @batters = data_loader.load_batting_data(File.expand_path(batting_file_path), @player)
        @batting_stats = Statistics.new
      end
  
      context "for all tests that require both the complete player and batting data file" do
        describe "statistical calculations for report" do
          
          describe "#most_improved_batting_average" do
            options = {:base_year => "2009", :compare_year => "2010", :limit_at_bats => 200}
            it "should return most improved batting average" do
              most_improved = @batting_stats.most_improved_batting_average(@batters, options)
              expect(most_improved[:player_id]).to eq("hamiljo03")
            end
          end
  
          describe "#team_slugging_percentage" do
            options = { :team_id => "OAK", :year_id => "2007"}
            it "should return most improved batting average" do
              team_slugging_percentage = @batting_stats.team_slugging_percentage(@batters, options)
              expect(team_slugging_percentage).to eq(40.70288685673301)
            end
          end
  
          describe "#triple_crown_winner for 2011 for AL" do
            options = {:year_id => "2011", :league => "AL", :limit => 400}
            it "should retun 'NO WINNER' if no player is found" do
              triple_crown_winner = @batting_stats.triple_crown_winner(@batters, options)
              expect(triple_crown_winner).to eq("Bobby Abreu")
            end
          end
  
          describe "#triple_crown_winner for 2012 for AL" do
            options = {:year_id => "2012", :league => "AL", :limit => 400}
            it "should retun 'NO WINNER' if no player is found" do
              triple_crown_winner = @batting_stats.triple_crown_winner(@batters, options)
              expect(triple_crown_winner).to eq("Dustin Ackley")
            end
          end
  
          describe "#triple_crown_winner for 2011 for NL" do
            options = {:year_id => "2011", :league => "NL", :limit => 400}
            it "should retun 'NO WINNER' if no player is found" do
              triple_crown_winner = @batting_stats.triple_crown_winner(@batters, options)
              expect(triple_crown_winner).to eq("Clint Barmes")
            end
          end
  
          describe "#triple_crown_winner for 2012 for NL" do
            options = {:year_id => "2012", :league => "NL", :limit => 400}
            it "should retun 'NO WINNER' if no player is found" do
              triple_crown_winner = @batting_stats.triple_crown_winner(@batters, options)
              expect(triple_crown_winner).to eq("Yonder Alonso")
            end
          end
        end
      end
  
      describe "statistics" do
        it "should be a kind of statistics" do
          batting_statistics = Statistics.new
          expect(batting_statistics).to be_a_kind_of(Statistics)
        end
      end
  
      describe "#initialize_player_data" do
        let(:row) { {'playerID' => 'aaronha01', 'birthYear' => 2011, 'nameFirst' => 'Hank', 'nameLast' => 'Aaron' } }
        let(:data) { Statistics.initialize_player_data row }
        it "initializes player data" do
          expect(data.player_id).to eq(row['playerID'])
          expect(data.player_birth_year).to eq(row['birthYear'])
          expect(data.player_first_name).to eq(row['nameFirst'])
          expect(data.player_last_name).to eq(row['nameLast'])
        end
      end
  
      describe "#initialize_batting_data" do
        let(:row) { {'playerID' => 'aardsda01', 'yearID' => 2011, 'league' => 'AL', 'teamID' => 'LAA', 'G' => 142,
                     'AB' => 502, 'R' => 54, 'H' => 127, '2B' => 30, '3B' => 1, 'HR' => 8, 'RBI' => 60,
                     'SB' => 21, 'CS' => 5 } }
        let(:data) { Statistics.initialize_batting_data row }
        it "initializes batting data" do
          expect(data.player_id).to eq(row['playerID'])
          expect(data.year_id).to eq(row['yearID'])
          expect(data.league).to eq(row['league'])
          expect(data.team_id).to eq(row['teamID'])
          expect(data.games).to eq(row['G'])
          expect(data.at_bats).to eq(row['AB'])
          expect(data.runs).to eq(row['R'])
          expect(data.hits).to eq(row['H'])
          expect(data.doubles).to eq(row['2B'])
          expect(data.triples).to eq(row['3B'])
          expect(data.home_runs).to eq(row['HR'])
          expect(data.runs_batted_in).to eq(row['RBI'])
          expect(data.stolen_bases).to eq(row['SB'])
          expect(data.caught_stealing).to eq(row['CS'])
        end
      end
    end
end