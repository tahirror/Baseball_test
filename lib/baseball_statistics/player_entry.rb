module Baseball

  class PlayerEntry
    attr_accessor :player_id, :player_first_name, :player_last_name, :player_birth_year, :player_full_name

    def initialize(args)
      raise ArgumentError.new 'args cannot be nil' if args.nil?
      @player_id = args.player_id
      @player_first_name = args.player_first_name
      @player_last_name = args.player_last_name
      @player_birth_year = args.player_birth_year
      @player_full_name = get_player_full_name(args.player_first_name, args.player_last_name)
    end

    def valid_name?(first_name, last_name)
      valid_string?(first_name) && valid_string?(last_name)
    end

    def valid_string?(string)
      !(string.nil? || string.empty?)
    end

    def get_player_full_name(first_name, last_name)
      if valid_name?(first_name, last_name)
        first_name + " " + last_name
      else
        "N/A"
      end
    end
  end
end