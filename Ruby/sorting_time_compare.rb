require_relative 'obj/numberlist.rb'

numbers= Array.new(10000) { rand(10000) }
list = NumberList.new(numbers)
puts "list size: #{list.to_a.size}"
puts

time1 = Time.new
list.sort
# puts list.sort.to_s
time2 = Time.new
puts "sort (system)   #{time2 - time1}"

time1 = Time.new
list.selection_sort
# puts list.selection_sort.to_s
time2 = Time.new
puts "selection sort  #{time2 - time1}"

time1 = Time.new
list.insertion_sort
# puts list.insertion_sort.to_s
time2 = Time.new
puts "insertion sort  #{time2 - time1}"

time1 = Time.new
list.bubble_sort
# puts list.bubble_sort.to_s
time2 = Time.new
puts "bubble sort  #{time2 - time1}"

time1 = Time.new
list.quick_sort
# puts list.quick_sort.to_s
time2 = Time.new
puts "quick sort  #{time2 - time1}"

time1 = Time.new
list.inplace_selection_sort
# puts list.inplace_selection_sort.to_s
time2 = Time.new
puts "inplace selection sort  #{time2 - time1}"
