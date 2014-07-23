require 'spec_helper'

module Baseball
  class PlayerEntrySpec
    describe PlayerEntry do
      describe "new player entry" do
        let(:row) { { 'playerID' => 'aaronha01', 'birthYear' => '1934', 'nameFirst' => 'Hank', 'nameLast' => 'Aaron' } }
        let(:data) { Statistics.initialize_player_data row}
        before(:each) do
          @player_entry = PlayerEntry.new(data)
        end
  
        it "should be a type of PlayerEntry" do
          expect(@player_entry).to be_a_kind_of(PlayerEntry)
        end
        it "should set the player_id" do
          expect(@player_entry.player_id).to eq('aaronha01')
        end
        it "should set the player_first_name" do
          expect(@player_entry.player_first_name).to eq('Hank')
        end
        it "should set the player_last_name" do
          expect(@player_entry.player_last_name).to eq('Aaron')
        end
        it "should set the player_birth_year" do
          expect(@player_entry.player_birth_year).to eq('1934')
        end
        it "should set the player_full_name" do
          expect(@player_entry.player_full_name).to eq('Hank Aaron')
        end
      end
    end
  end
end