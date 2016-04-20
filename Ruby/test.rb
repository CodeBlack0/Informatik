require_relative 'obj/numberlist.rb'

numlist = NumberList.new()
numlist.populate(20)

puts numlist.inplace_insertion_sort.to_s