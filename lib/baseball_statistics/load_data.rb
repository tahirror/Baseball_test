require 'csv'
require 'syslog'
require 'configuration'
require_relative '../../lib/baseball_statistics/statistics'
require_relative 'player_entry'

module Baseball
  class LoadData
    BATTING_PRE_PROCESSED_FILE_PATH = File.expand_path('data/Batting-07-12.csv')
    PLAYER_PRE_PROCESSED_FILE_PATH = File.expand_path('data/Master-small.csv')

    def load_player_data(file_path)
      raise ArgumentError.new 'File Path required' if file_path.empty?
      #@file_path = "/Users/mtahir/Downloads/Developer Candidate Exercise/Master-small.csv"
      @file_path = clean_input_file(file_path, PLAYER_PRE_PROCESSED_FILE_PATH)
      @csv_options = build_options_hash(Configuration.for 'csv_options')
      @roster = []
      @players_by_id = {}
      @line_count = 0

      begin
        CSV.foreach(@file_path, @csv_options) do |row|
          @line_count += 1
          player_data = Statistics.initialize_player_data row
          next unless player_data_clean?(player_data)
          find_or_create_player_entry(player_data)
        end
        log_successful_import(@file_path, @line_count)
      rescue CSV::MalformedCSVError => error
        log_failed_import(@file_path, error)
        raise
      end
      @roster
    end

    def load_batting_data(file_path, roster)
      #file_path = "/Users/mtahir/Downloads/Developer Candidate Exercise/Batting-07-12.csv"
      file_path = clean_input_file(file_path, BATTING_PRE_PROCESSED_FILE_PATH)
      csv_options = build_options_hash(Configuration.for 'csv_options')
      @batters = []
      @batters_by_id = {}
      @line_count = 0
      begin
        CSV.foreach(file_path, csv_options) do |row|
          @line_count += 1
          batter_data = Statistics.initialize_batting_data row
          next unless batting_data_clean?(batter_data)
          find_or_create_batter(batter_data, roster)
        end
        log_successful_import(file_path, @line_count)
      rescue CSV::MalformedCSVError => error
        log_failed_import(file_path, error)
        raise
      rescue => error
        log_failed_import(file_path, error)
        raise
      end
      @batters_by_id
    end

    private
    def build_options_hash(options)
       hash = {}
       hash[:headers] = options.headers
       hash[:col_sep] = options.col_sep
       hash[:row_sep] = options.row_sep
       hash[:quote_char] = options.quote_char
       hash[:field_size_limit] = options.field_size_limit
       hash[:converters] = options.converters
       hash[:unconverted_fields] = options.unconverted_fields
       hash[:headers] = options.headers
       hash[:return_headers] = options.return_headers
       hash[:write_headers] = options.write_headers
       hash[:skip_blanks] = options.skip_blanks
       hash[:force_quotes] = options.force_quotes
       hash[:encoding] = options.encoding
       hash
    end

    def find_or_create_player_entry(data)
      if @players_by_id[data.player_id]
        @players_by_id[data.player_id]
      else
        temp_roster = PlayerEntry.new(data)
        @players_by_id[data.player_id] = temp_roster
        @roster << temp_roster
      end
    end

    def find_or_create_batter(data, roster)
      data = get_batting_average(data)
      data = update_full_name(data, roster)
      if @batters_by_id[data.player_id]
        @batters_by_id[data.player_id] << data
      else
        @batters_by_id[data.player_id] = [data]
      end
    end

    def get_batting_average(data)
      data.batting_average = compute_batting_average(data)
      data
    end

    def compute_batting_average(data)
      if data.hits == 0 || data.at_bats == 0
        0
      else
       Float("%.3g" % ((data.hits * 1.0)/data.at_bats))
      end
    end

    def update_full_name(data, roster)
        temp_entry = roster.detect { |entry| next unless entry.player_id == data.player_id; entry; }
        data.player_full_name = temp_entry.player_first_name + " " + temp_entry.player_last_name
        data
    end

    def clean_input_file(file_path, pre_processed_file_path)
      command = "tr '\\n' '\\r' < #{file_path} > #{pre_processed_file_path}"
      system(command)
      pre_processed_file_path
    end

    def player_data_clean?(data)
      valid_string?(data.player_id) && 
      valid_string?(data.player_birth_year) && 
      valid_string?(data.player_first_name) &&
      valid_string?(data.player_last_name)
    end

    def batting_data_clean?(data)
      valid_string?(data.player_id) &&
      valid_string?(data.year_id) &&
      valid_string?(data.league) &&
      valid_string?(data.team_id) &&
      valid_integer?(data.games) &&
      valid_integer?(data.at_bats) &&
      valid_integer?(data.runs) &&
      valid_integer?(data.hits) &&
      valid_integer?(data.doubles) &&
      valid_integer?(data.triples) &&
      valid_integer?(data.home_runs) &&
      valid_integer?(data.runs_batted_in) &&
      valid_integer?(data.stolen_bases) &&
      valid_integer?(data.caught_stealing)
    end

    def valid_string?(string)
      !(string.nil? || string.empty?)
    end

    def valid_integer?(value)
      value.is_a? Integer
    end

    def log_successful_import(file_path, line_count)
      Syslog.open('Baseball', Syslog::LOG_PID, Syslog::LOG_LOCAL5)
      Syslog.log(Syslog::LOG_INFO, "Successful File Import => file_path = #{file_path}, line_count = #{line_count}")
      Syslog.close()
    end

    def log_failed_import(file_path, exception)
      Syslog.open('Baseball', Syslog::LOG_PID, Syslog::LOG_LOCAL5)
      Syslog.log(Syslog::LOG_ERR, "File Import Failed => file_path = #{file_path} Exception Message: #{exception.inspect}")
      Syslog.close()
    end
  end
end