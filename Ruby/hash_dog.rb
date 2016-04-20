require_relative "obj/dog"

dogs = {}
(1 .. 3).each do |num|
  dog = Dog.new(num.to_s, 5 * num)
  dogs[dog.name] = dog
end

dogs.each do |name, barker|
  barker.bark
end
