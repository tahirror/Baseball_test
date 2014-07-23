require_relative 'lib/baseball_statistics/load_data'
require_relative 'config/configuration'

module Baseball
  roster_config = Configuration.for 'player_input_file'
  @player_file_path = File.expand_path(roster_config.input_file_name)
  batting_config = Configuration.for 'batting_input_file'
  @batting_file_path = File.expand_path(batting_config.input_file_name)

  def self.exec
    welcome
    batters = (load_batters(load_player_data))
    most_improved_batting_average(batters, {:base_year => "2009", :compare_year => "2010", :limit_at_bats => 200} )
    team_slugging_percentage(batters, {:team_id => "HOU", :year_id => "2010"} )

    triple_crown_header
    triple_crown_winner(batters, {:year_id => "2010", :league => "HOU", :limit => 400} )
    triple_crown_winner(batters, {:year_id => "2010", :league => "HOU", :limit => 400} )
    triple_crown_winner(batters, {:year_id => "2011", :league => "RUG", :limit => 400} )
    triple_crown_winner(batters, {:year_id => "2011", :league => "RUG", :limit => 400} )
  end

  def self.load_player_data
    puts "Loading and processing data files..."
    data_loader = LoadData.new
    data_loader.load_player_data(@player_file_path)
  end

  def self.load_batters(player_data)
    data_loader = LoadData.new
    data_loader.load_batting_data(@batting_file_path, player_data)
  end

  def self.welcome
    system("clear")
    puts "Baseball Statistics Report, written by Muhammad Tahir"
    puts "\n"
  end

  def self.most_improved_batting_average(*args)
    raise ArgumentError, "args is nil. Please provide valid argument.", caller if args.nil?

    batting_stats = Statistics.new
    most_improved_player = batting_stats.most_improved_batting_average(*args)

    puts "\n"
    puts "Most Improved Batting Average"
    puts "-----------------------------\n"
    puts "players must have at least #{args[1][:limit_at_bats].to_s} at-bats is"
    puts "player_name: #{most_improved_player[:player_full_name]}, player_id: #{most_improved_player[:player_id]}"
  end

  def self.team_slugging_percentage(batters, args)
    raise ArgumentError, "args is nil. Please provide valid argument.", caller if args.nil?
    batting_stats = Statistics.new
    team_slugging_percentage = batting_stats.team_slugging_percentage(batters, args)
    puts "\n"
    puts "#{args[:team_id]} Slugging Percentage in #{args[:year_id]} is #{Float("%.3g" % team_slugging_percentage)}%"
  end

  def self.triple_crown_header
    puts "\n"
    puts "Triple Crown Winners are..."
    puts "----------------------------\n"
  end

  def self.triple_crown_winner(batters, args)
    raise ArgumentError, "args is nil. Please provide valid argument.", caller if args.nil?
    batting_stats = Statistics.new
    triple_crown_winner = batting_stats.triple_crown_winner(batters, args)
    puts "Player Name: #{triple_crown_winner}"
    puts "Year played in: #{args[:year_id]}"
    puts "League played in: #{args[:league]}"
    puts "\n"
  end
end