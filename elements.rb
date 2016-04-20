#-c 																							--> toggles command mode, allowing for commands of 2 and more arguments in length to be used
#-i 																							--> shows current settings
#-a 																							--> shows all the stoed data
#-r:[focus type] 																	--> sets the result focus to a certain type
#-s:[focus type] 																	--> sets the seach focus to a certain type
#-e:[search term]																	--> shows all stored data to selected element (term type enforced by search focus)
#-e:[search focus]:[search term]  								--> shows all stored data to selected element (term type used difined in first argument)
#-e:[search focus]:[search term]:[result focus]   --> shows data determined by resultfocus of selected element (term type used difined in first argument)




#------read out the elements.csv
elements = []
raw_data = File.read('resources/documents/csv/elements.csv').split("\n")
raw_data.each do |raw|
	temp = raw.split('"')						#spliting to pickout the decimal atommasses
	data = temp[0].split(',') 			#spliting the rest along the commas
	data << temp[1]                 #readding atommasses if needed
  elements << [data[0],data[1],data[2],data[3],data[4],data[5],data[6]] #feading data into 'list' of the elements
end
elements.delete_if { |e| e.include? "Name"}		#getting rid oof the csv headers

command_mode = false
trip = false
focus_s = "ordnungszahl"
focus_r = "name"
foci = {"ordnungszahl" => 0,    #setting up hash to corelate different foci to different values in the element arrays
				"name" 				 => 1, 
				"symbol" 			 => 2, 
				"gruppe" 			 => 3, 
				"periode" 		 => 4, 
				"block" 			 => 5, 
				"atommasse"		 => 6}

#------user interface
puts "Enter '-?' for all possible commands, type quit to exit"
loop do
	query = command_mode ? ">> " : focus_s.capitalize + ": " #selecting properquery based on operating mode
  print query.to_s 					                #asking for input
  input = gets.chomp.downcase               #reading input
  
  if input == "quit"
  	break

  elsif input.include? "-" 									#fetching command
    temp = input.index("-")                 #locating command
    cmd = input[temp+1..-1].split(":")      #extracting and splitting command

    if cmd.length == 1										  #checking for base commandtype: length == 1
    	if cmd[0] == 'i'											#show info command
    		puts "  -| focus s: " + focus_s.to_s.capitalize
    		puts "  -| focus r: " + focus_r.to_s.capitalize
    	elsif cmd[0] == 'a'                   #show all element data command
        elements.each do |element|          #cycling elements
        	puts "  -> " + element.to_s       #print element
        end 
      elsif cmd[0] == 'c'										#toggle command mode command
      	command_mode = command_mode ? false : true
      elsif cmd[0] == 'f'										#foci command
      	puts "  -| possible foci: Ordnungszahl, Name, Symbol, Gruppe, Periode, Block, Atommasse"
    	elsif cmd[0] == '?'										#help command
				puts "\n -?\n  --> shows commands and their explanations"
    		puts "\n -c\n  --> toggles command mode, allowing for commands of 2 and more arguments in length to be used"
				puts "\n -i\n  --> shows current settings"
				puts "\n -a\n  --> shows all the stoed data"
				puts "\n -f\n  --> shows all possible foci"
				puts "\n -r:[focus type]\n  --> sets the result focus to a certain type"
				puts "\n -s:[focus type]\n  --> sets the seach focus to a certain type"
				puts "\n -e:[search term]\n  --> shows all stored data to selected element (term type enforced by search focus)"
				puts "\n\n\n <<!>> Following commands need command mode to become usable"
				puts "\n -e:[search focus]:[search term]\n  --> shows all stored data to selected element (term type used difined in first argument)"
				puts "\n -e:[search focus]:[search term]:[result focus]\n  --> shows data determined by resultfocus of selected element (term type used difined in first argument)"
    	end

    elsif cmd.length == 4 and command_mode  #checking for base command type: length == 4 and command mode
      if cmd[0] == 'e' and foci.include? cmd[1].downcase and foci.include? cmd[3].downcase
				elements.each do |element|														#cycling elements array
					if element[foci[cmd[1]]] == cmd[2].capitalize			  #selecting the correct element based on command input
						puts "  -> " + element[foci[cmd[3]]].to_s         #print the correct element data based on command input
				  end
				end
			end	

    elsif cmd.length == 3 and command_mode  #checking for base command type: length == 3 and command mode
      if cmd[0] == 'e' and foci.include? cmd[1].downcase
				elements.each do |element|														#cycling elements array
					if element[foci[cmd[1]]] == cmd[2].capitalize			  #selecting the correct element based on command input
						puts "  -> " + element.to_s                       #print all element data
				  end
				end
			end

    elsif cmd.length == 2                   	#checking for base command type: length == 2
    	if (cmd[0] == 's' or cmd[0] == 'r') 		#checking for specifc commands and comand requirements  
    		if foci.include? cmd[1].downcase
		    	if cmd[0] == "s"										#set search focus command
		    		focus_s = cmd[1].downcase
		    		puts "  -| focus s: " + focus_s.to_s.capitalize
		    	elsif cmd[0] == "r" 								#set result focus command
		    		focus_r = cmd[1].downcase
		    		puts "  -| focus r: " + focus_r.to_s.capitalize
		    	else																#throwing errors
		    		puts "  -| invalid command, please pick from: r [set result focus], s [set search focus]"
		    	end
		    else
		    	puts "  -| invalid focus, plaese pick from: Ordnungszahl, Name, Symbol, Gruppe, Periode, Block, Atommasse"
				end	
	    elsif cmd[0] == 'e'
				elements.each do |element|														#cycling elements array
					if element[foci[focus_s]] == cmd[1].capitalize			#selecting the correct element based on command input
						puts "  -> " + element.to_s                       #print all element data
				  end
				end  
			end
	  end

	else
		elements.each do |element|																						#cycling elements array
			if element[foci[focus_s]] == input.capitalize												#selecting the correct element based on focus_s
				puts "  -> " + focus_r.capitalize + ": " + element[foci[focus_r]] #print the correct result based on foucs_r
				trip = true																												#tripping hook for finding the fitting element
			end
		end
		if trip != true														#reading hook to see if fitting element was found
      puts "  -| unbekanntes Element"         #throwing error
      trip = false														#reseting hook
    end
  end
end
