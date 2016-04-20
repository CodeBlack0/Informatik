#getting input
print "Enter N: "
n = gets.chomp.to_i
print "Enter e: "
e = gets.chomp.to_i

#creating ras cyphercodes
puts "---------------------------------------------"
cyphercodes = []
(0 .. n-1).each do |num|
	cyphercodes << (num**e%n)
end

#check if there are any dups
if cyphercodes.uniq.length != cyphercodes.length
	puts "invalid e! (duplicates)"
	print "print anymway? [y/n]: "
	choice = gets.chomp.downcase
	if choice == 'y'
		puts "---------------------------------------------"
		(0 .. n-1).each do |num|
			puts "[#{num}]: " + cyphercodes[num].to_s
		end
	else 
		return
	end
else
	(0 .. n-1).each do |num|
		puts "[#{num}]: " + cyphercodes[num].to_s
	end
end
	
#pause closing
gets