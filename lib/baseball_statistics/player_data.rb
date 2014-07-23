module Baseball
  class PlayerData
    attr_accessor :player_id, :player_full_name
    def initialize(args={}, player)
      raise ArgumentError.new 'args and player cannot be nil' if (args.nil? || player.nil?)
      @player_id = args.player_id
      @player_full_name = get_player_full_name(args, player)
    end

    private
    def get_player_full_name(args, player)
      player_id_to_find = args.player_id
      player.each do |r|
        if r.player_id == player_id_to_find
          return (r.player_first_name + " " + r.player_last_name)
        else
          "No fullname for this player."
        end
      end
    end
  end
end