require 'configuration'

Configuration.for('player_input_file') {
  input_file_name '../data/Master-small.csv'
}

Configuration.for('batting_input_file') {
  input_file_name '../data/Batting-07-12.csv'
}

Configuration.for('csv_options') {
  col_sep ','
  row_sep :auto
  quote_char '"'
  field_size_limit nil
  converters nil
  unconverted_fields nil
  headers true
  return_headers false
  write_headers false
  skip_blanks false
  force_quotes false
  encoding 'UTF-8'
}