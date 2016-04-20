require_relative "obj/dog.rb"

dogs = []
(1 .. 5).each do |num|
  dogs << Dog.new("#{num}", 5*num)
end

dogs.each do |dog|
  dog.bark
end
