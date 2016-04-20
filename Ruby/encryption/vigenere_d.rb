#defining alphabets
abc = "abcdefghijklmnopqrstuvwxyz"
abc2 = abc + abc

#getting input
print "Enter cypher text: "
cypher = gets.chomp
print "Enter key: "
key = gets.chomp

#creating keystrip
full_counts = cypher.length / key.length
half_counts = cypher.length % key.length
strip = ""
full_counts.times do
	strip += key
end
strip += key[0,half_counts]

#creating cypher
plain = ""
(1 .. cypher.length).each do |pos|
	index = abc.index(strip[pos - 1])
	plain_abc = abc2[index,25]
	plain[pos - 1] = cypher[pos - 1].tr(plain_abc,"a-z")
end
puts "plain: " + plain

#pause closing
gets