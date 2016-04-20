#defining alphabets
abc = "abcdefghijklmnopqrstuvwxyz"
abc2 = abc + abc

#getting input
print "Enter plain text: "
plain = gets.chomp
print "Enter key [a-z]: "
key = gets.chomp

#encrypting plain text
puts "[key: #{key}] " + plain.tr("a-z",abc2[abc.index(key),25])

#pause closing
gets