require "csv"
require_relative "obj/country.rb"


countries = Hash.new { |h,k| h[k] = Country }
CSV.foreach("resources/documents/csv/countries.csv", col_sep: ";", headers: true) do |row|
  countries[row[1]] = Country.new(row[0],row[1],row[2],row[3],row[4],row[5])
end

loop do
  input = ""
  print "Land: " 
  input = gets.chomp.downcase.capitalize
  if(input == "Quit")
    break
  elsif(countries.has_key?(input))
    puts "  -> " + countries[input].capital
  else
    puts "  -| unbekanntes Land"
  end
end

