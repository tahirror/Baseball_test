require 'spec_helper'
require '../../config/configuration'

module Baseball
  class LoadDataSpec
    describe LoadData do
      before(:all) do
        player_config = Configuration.for 'player_input_file'
        player_file_path = File.expand_path(player_config.input_file_name)
        batting_config = Configuration.for 'batting_input_file'
        batting_file_path = File.expand_path(batting_config.input_file_name)
        load_data = LoadData.new
        @player = load_data.load_player_data(player_file_path)
        load_data = LoadData.new
        @batters = load_data.load_batting_data(File.expand_path(batting_file_path), @player)
      end
  
      context "for all tests that require both the complete roster and batting data file" do
        describe "data loader for roster" do
          it "should be a kind of array" do
            expect(@player).to be_kind_of(Array)
          end
          
          it "should have a valid player_id" do
            expect(@player[0].player_id).to eq("aaronha01")
          end
          
          it "should have a valid player_first_name" do
            expect(@player[0].player_first_name).to eq("Hank")
          end
          
          it "should have a valid player_last_name" do
            expect(@player[0].player_last_name).to eq("Aaron")
          end
          
          it "should have a valid player_birth_year" do
            expect(@player[0].player_birth_year).to eq("1934")
          end
          
          it "should have a valid player_full_name" do
            expect(@player[0].player_full_name).to eq("Hank Aaron")
          end
        end
  
        describe "data loader for batting data" do
          before(:all) do
            @batter_to_test = @batters["aardsda01"]
          end
  
          it "should be a kind of hash" do
            expect(@batters).to be_kind_of(Hash)
          end
  
          it "should have valid data for player abreubo01" do
            expect(@batter_to_test[0].player_id).to eq("aardsda01")
            expect(@batter_to_test[0].year_id).to eq(@year_id="2012")
            expect(@batter_to_test[0].league).to eq(@league="AL")
            expect(@batter_to_test[0].team_id).to eq(@team_id="NYA")
            expect(@batter_to_test[0].games).to eq(@games=1)
            expect(@batter_to_test[0].at_bats).to eq(@at_bats=0)
            expect(@batter_to_test[0].runs).to eq(@runs=0)
            expect(@batter_to_test[0].hits).to eq(@hits=0)
            expect(@batter_to_test[0].doubles).to eq(@doubles=0)
            expect(@batter_to_test[0].triples).to eq(@triples=0)
            expect(@batter_to_test[0].home_runs).to eq(@home_runs=0)
            expect(@batter_to_test[0].runs_batted_in).to eq(@runs_batted_in=0)
            expect(@batter_to_test[0].stolen_bases).to eq(@stolen_bases=0)
            expect(@batter_to_test[0].caught_stealing).to eq(@caught_stealing=0)
            expect(@batter_to_test[0].batting_average).to eq(@batting_average=0)
            expect(@batter_to_test[0].player_full_name).to eq(@player_full_name="David Aardsma")
          end
        end
      end
    end
  end
end