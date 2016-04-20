#defining alphabets
abc = "abcdefghijklmnopqrstuvwxyz"
abc2 = abc + abc

#getting input
print "Enter plain text: "
plain = gets.chomp
print "Enter key: "
key = gets.chomp

#creating keystrip
full_counts = plain.length / key.length
half_counts = plain.length % key.length
strip = ""
full_counts.times do
	strip += key
end
strip += key[0,half_counts]

#creating cypher
cypher = ""
(1 .. plain.length).each do |pos|
	index = abc.index(strip[pos - 1])
	cypher_abc = abc2[index,25]
	cypher[pos - 1] = plain[pos - 1].tr("a-z",cypher_abc)
end
puts "cypher: " + cypher

#pause closing
gets