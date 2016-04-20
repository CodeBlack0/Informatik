#defining alphabets
abc = "abcdefghijklmnopqrstuvwxyz"
abc2 = abc + abc

#getting input
print "Enter cypher text: "
cypher = gets.chomp

#decrypting with all possible keys
("a" .. "z").each do |key|
	puts "[#{key}]: " + cypher.tr(abc2[abc.index(key),25],"a-z")
/# Translates cypher from the keys alphabet to the normal alphabet.
   The keys alphabet is given through the index of the in the normal
   alphabet and the extracting the following 25 letters from a 
   "doubled" alphabet. 
   ---[expanded code]---
   index = abc.index(key)
   new_abc = abc2[index,25]
   plain = cypher.tr(new_abc,abc)
   puts "[" + key.to_s + "]: " + plain
   #/
end

#pause closing
gets