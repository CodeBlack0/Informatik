require_relative 'csv_interface.rb'
class CSV_UI
  attr_reader :csv

  def initialize(csv = CSV.new(''))
    @csv = csv
  end

  def run_ui()
    if @csv.valid
      puts "Usage: [Search focus]:[search Term]:[Result focus] \ntype i or foci for information on possible filters"
      loop do
        print ">> "
        input = gets.chomp.downcase
        cmd = input.split(":").each {|e| e.to_s}
        if cmd[0] != nil
  	  if cmd.length == 3 && @csv.foci.has_key?(cmd[0]) #&& @csv.foci.has_key?(cmd[2])
            data = @csv.get_specific_data(cmd[0],cmd[1],cmd[2])
            out = data == nil ? ["couldn't find that"] : data
            out.each do |line|
              puts line.to_s
            end
          elsif cmd.length == 2 && @csv.foci.has_key?(cmd[0])
            data = @csv.get_focus_data(cmd[0],cmd[1])
            out = data == nil ? ["couldn't find that"] : data
            out.each do |line|
              puts line.to_s
            end
          elsif cmd.length == 1 && @csv.foci.has_key?(cmd[0])
            data = @csv.get_focus_data(cmd[0], nil)
            out = data == nil ? ["couldn't find that"] : data
            out.each do |line|
              puts line.to_s
            end
          elsif cmd[0].downcase == 'i' || cmd[0].downcase == 'foci'
            puts "NUM : FOCUS \t\t : UNITS"
            @csv.foci.each do |k,v|
              puts v.to_s + (v < 10 ? '  ' : ' ') + ' : ' + k  + (k.length >= 12 ? "\t" : "\t\t") +" : " + (@csv.units[v] != ' ' ? @csv.units[v] : '---')
            end
          elsif cmd[0].downcase == 'a' || cmd[0].downcase == 'all'
            out = @csv.debug_readout()
            puts "<DATA>-------------------------------"
            out['DATA'].each do |e|
              puts e.to_s
            end
            puts "<FOCI>-------------------------------"
            out['FOCI'].each do |e|
              puts e.to_s
            end
            puts "<UNITS>------------------------------"
            out['UNITS'].each do |e|
              puts e.to_s
            end
            puts "<STD FOCI>---------------------------"
            out['STD FOCI'].each do |e|
              puts e.to_s
            end
          elsif cmd[0].downcase == 'c' || cmd[0].downcase == 'clear'
            Gem.win_platform? ? (system "cls") : (system "clear")
          elsif cmd[0].downcase == 'quit' || cmd[0].downcase == 'q' || cmd[0].downcase == 'exit' || cmd[0].downcase == 'e'
            break
          end
        end
      end
    else
      print "No valid path was given"
      gets
    end
  end
end
