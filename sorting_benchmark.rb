require 'benchmark'
require_relative 'obj/numberlist.rb'

numbers= Array.new(200000) { rand(200000) }
list = NumberList.new(numbers)
puts "list size: #{list.to_a.size}"
puts

Benchmark.bm(15) do |bm|
  bm.report("sort (system)")  { list.sort }
  bm.report("selection_sort") { list.selection_sort }
  bm.report("insertion_sort") { list.insertion_sort }
  bm.report("bubble_sort") { list.bubble_sort }
  bm.report("quick_sort") { list.quick_sort }
  bm.report("i_selection_sort") { list.inplace_selection_sort }
end
