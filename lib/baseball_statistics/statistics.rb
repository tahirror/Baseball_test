module Baseball

  class Statistics
    attr_accessor :player_id, :year_id, :league, :team_id, :games, :at_bats, :runs, :hits, :doubles, :triples, :home_runs, 
                  :runs_batted_in, :stolen_bases, :caught_stealing, :batting_average, :player_birth_year, :player_first_name, 
                  :player_last_name, :player_full_name, :team_slugging_percentage, :triple_crown_winner

    def initialize
      @hits = hits
      @at_bats = at_bats
    end

    def self.initialize_player_data(row)
      data = Statistics.new
      data.player_id = row['playerID']
      data.player_birth_year = row['birthYear']
      data.player_first_name = row['nameFirst']
      data.player_last_name = row['nameLast']
      data
    end

    def self.initialize_batting_data(row)
      data = Statistics.new
      data.player_id = row['playerID']
      data.year_id = row['yearID']
      data.league = row['league']
      data.team_id = row['teamID']
      data.games = row['G'].to_i
      data.at_bats = row['AB'].to_i
      data.runs = row['R'].to_i
      data.hits = row['H'].to_i
      data.doubles = row['2B'].to_i
      data.triples = row['3B'].to_i
      data.home_runs = row['HR'].to_i
      data.runs_batted_in = row['RBI'].to_i
      data.stolen_bases = row['SB'].to_i
      data.caught_stealing = row['CS'].to_i
      data.batting_average = nil
      data.player_full_name = nil
      data
    end

    def most_improved_batting_average(batters, args={})
      raise ArgumentError.new 'args cannot be nil' if (batters.nil? || args.nil?)

      @base_year = args[:base_year]
      @compare_year = args[:compare_year]
      @limit_at_bats = args[:limit_at_bats]
      @line_count = 0
      @most_improved = {}
      
      batters.each do |key, value|
        @line_count += 1
        player_id = key
        data_by_year = value
        player_full_name = value[0].player_full_name
        base_year_data = data_by_year.detect { |data| next unless data.year_id == @base_year; 
          if data.at_bats > @limit_at_bats; 
            data; 
          end 
        }
        compare_year_data = data_by_year.detect { |data| next unless data.year_id == @compare_year; 
          if data.at_bats > @limit_at_bats; 
            data; 
          end 
        }
        batting_average_base_year = base_year_data.batting_average if !base_year_data.nil?
        batting_average_compare_year = compare_year_data.batting_average if !compare_year_data.nil?
        delta = batting_average_base_year <=> batting_average_compare_year

        case delta
          when 0
            @delta_flag = 0.0 #same - no improvement
          when 1
            @delta_flag = -1.0 #<= NO, there was no improvement
          when -1
            @delta_flag = (batting_average_compare_year * 1.0 - batting_average_base_year) #<= YES there was improvement
        end

        if @delta_flag > 0.0 && @delta_flag < 1.0
          if @most_improved.empty?
            @most_improved[:player_id] = player_id
            @most_improved[:player_full_name] = player_full_name
            @most_improved[:delta] = @delta_flag
          end
          if !@most_improved[:delta].nil? && (@most_improved[:delta] < @delta_flag)
            @most_improved[:player_id] = player_id
            @most_improved[:player_full_name] = player_full_name
            @most_improved[:delta] = @delta_flag
          end
        end
      end
      @most_improved
    end

    def team_slugging_percentage(batters, args={})
      raise ArgumentError.new 'args cannot be nil' if (batters.nil? || args.nil?)
      @team_id = args[:team_id]
      @year_id = args[:year_id]
      @hits = @at_bats = @doubles = @triples = @home_runs = 0

      batters.each do |key, value|
        slugging_data = value.detect {|data| next unless data.year_id == @year_id && data.team_id == @team_id; data;}
        if slugging_data
          @hits += slugging_data.hits
          @at_bats += slugging_data.at_bats
          @doubles += slugging_data.doubles
          @triples += slugging_data.triples
          @home_runs += slugging_data.home_runs
        end
      end
      @team_slugging_percentage=(((@hits-@doubles-@triples-@home_runs)+(2.0*@doubles)+(3.0*@triples)+(4.0*@home_runs))/@at_bats )*100.0
    end

    def triple_crown_winner(batters, args={})
      raise ArgumentError.new 'args cannot be nil' if (batters.nil? || args.nil?)
      @year_id = args[:year_id]
      @league = args[:league]
      @limit_at_bats = args[:limit]
      @highest_batting_average = {}
      @most_home_runs = {}
      @most_rbis = {}
      @triple_crown_winner = ""

      batters.each do |key, value|
        candidate = value.detect { |data| next unless data.year_id == @year_id && data.league == @league; if data.at_bats > @limit_at_bats; data; end}
        if !candidate.nil?
          if @highest_batting_average.empty?
            @highest_batting_average[candidate.player_id] = {:player_full_name => candidate.player_full_name, :batting_average => candidate.batting_average}
          end
          if @most_home_runs.empty?
            @most_home_runs[candidate.player_id] = {:player_full_name => candidate.player_full_name, :home_runs => candidate.home_runs}
          end
          if @most_rbis.empty?
            @most_rbis[candidate.player_id] = {:player_full_name => candidate.player_full_name, :runs_batted_in => candidate.runs_batted_in}
          end
          if (candidate.batting_average <=> @highest_batting_average[candidate.player_id]) == 1
            @highest_batting_average[candidate.player_id] = {:player_full_name => candidate.player_full_name, :batting_average => candidate.batting_average}
          end
          if (candidate.home_runs <=> @most_home_runs[candidate.player_id]) == 1
            @most_home_runs[candidate.player_id] = {:player_full_name => candidate.player_full_name, :home_runs => candidate.home_runs}
          end
          if (candidate.runs_batted_in <=> @most_rbis[candidate.player_id]) == 1
            @most_rbis[candidate.player_id] = {:player_full_name => candidate.player_full_name, :runs_batted_in => candidate.runs_batted_in}
          end
        end
      end
      if !@highest_batting_average.empty? && !@most_home_runs.empty? && !@most_rbis.empty?
        if @highest_batting_average.keys.first == @most_home_runs.keys.first && @highest_batting_average.keys.first == @most_rbis.keys.first
          @triple_crown_winner = @highest_batting_average[@highest_batting_average.keys.first][:player_full_name]
        end
      else
        @triple_crown_winner = "NO WINNER"
      end
      @triple_crown_winner
    end
  end
end