#getting input
print "Enter N: "
n = gets.chomp.to_i
print "Enter e: "
e = gets.chomp.to_i
print "Enter d: "
d = gets.chomp.to_i

#creating ras cyphercodes and d validity check
cyphercodes = []
valid = true
(0 .. n-1).each do |num|
	en = (num**e%n)
	dn = (en**d%n)
	if dn != num
		valid = false
	end
	cyphercodes << en
end
puts "---------------------------------------------"

#check d's validity
if not valid
	puts "invalid d! (can't decrypt properly)"
	gets
end

#check if there are any dups
if cyphercodes.uniq.length != cyphercodes.length
	puts "invalid e! (duplicates)"
	print "print anymway? [y/~]: "
	choice = gets.chomp.downcase
	if choice != 'y'
		return
	end
end

#print cyphercodes
puts "---------------------------------------------"
(0 .. n-1).each do |num|
	puts "[#{num}]: " + cyphercodes[num].to_s
end

#pause closing
gets