#getting input
print "Enter plain text: "
plain = gets.chomp

#applying rot13 cypher
cypher = plain.tr("a-z","n-za-m")
print "cypher: #{cypher}"

#pause closing
gets