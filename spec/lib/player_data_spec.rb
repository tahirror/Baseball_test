require 'spec_helper'

module Baseball
  class PlayerDataSpec
    describe PlayerData do
      let(:row1) { {'playerID' => 'aaronha01', 'birthYear' => 1934, 'nameFirst' => 'Hank', 'nameLast' => 'Aaron' } }
      let(:data1) { Statistics.initialize_player_data row1 }
      let(:player_entry_1) { Baseball::PlayerEntry.new data1 }
  
      let(:row2) { {'playerID' => 'bernavi01', 'birthYear' => 1953, 'nameFirst' => 'Victor', 'nameLast' => 'Bernal' } }
      let(:data2) { Statistics.initialize_player_data row2 }
      let(:player_entry_2) { Baseball::PlayerEntry.new data2 }
  
      let(:row3) { {'playerID' => 'bernacu01', 'birthYear' => 1952, 'nameFirst' => 'Curt', 'nameLast' => 'Bernard' } }
      let(:data3) { Statistics.initialize_player_data row3 }
      let(:player_entry_3) { Baseball::PlayerEntry.new data3 }
  
      let(:row4) { {'playerID' => 'bernacu01', 'birthYear' => 1952, 'nameFirst' => 'Curt', 'nameLast' => 'Bernard' } }
      let(:data4) { Statistics.initialize_player_data row4 }
      let(:player_entry_4) { Baseball::PlayerEntry.new data4 }
  
      let(:row5) { {'playerID' => 'berroge01', 'birthYear' => 1965, 'nameFirst' => 'Geronimo', 'nameLast' => 'Berroa' } }
      let(:data5) { Statistics.initialize_player_data row5 }
      let(:player_entry_5) { Baseball::PlayerEntry.new data5 }
  
      let(:player) { [player_entry_1, player_entry_2, player_entry_3, player_entry_4, player_entry_5 ] }
  
      let(:row) { {'playerID' => 'aaronha01', 'yearID' => 2011, 'league' => 'AL', 'teamID' => 'LAA', 'G' => 142,
                   'AB' => 502, 'R' => 54, 'H' => 127, '2B' => 30, '3B' => 1, 'HR' => 8, 'RBI' => 60,
                   'SB' => 21, 'CS' => 5 } }
      let(:data) { Statistics.initialize_batting_data row }
  
      describe "when we create a new player" do
        before(:each) do
          @player = PlayerData.new(data, player)
        end
        it "should be a kind of player" do
          expect(@player).to be_kind_of(Player)
        end
        it "should set the player_id " do
          expect(@player.player_id).to eq("aaronha01")
        end
        it "should set the player full name" do
          expect(@player.player_full_name).to eq("Hank Aaron")
        end
      end
    end
  end
end