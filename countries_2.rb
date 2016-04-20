require_relative 'obj/csv_interface.rb'
require_relative 'obj/csv_ui.rb'

csv = CSV_UI.new(CSV_Interface.new( 'resources/documents/csv/countries.csv', {"split_symbol" => ';'}))
csv.run_ui()