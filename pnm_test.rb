require "pnm"
require_relative 'obj/pnm_converter.rb'
require_relative 'obj/pnm_generator.rb'

converter = PNMConverter.new
generator = PNMGenerator.new({:h => 500, :w => 300, :d => 50})

def f(x)
  Math::E ** (0.01 * x)
end

image = PNM.read("resources/images/originals/kitten.ppm")
converter.invert(image).write("resources/images/edited/kitten_i.ppm")

#converter.blur(image, 3).write("resources/images/edited/rectangle_A_b3.pgm")


#image2 = generator.function(method(:f))
#converter.add(image, image2).write("resources/images/generated/circle_A_+_halfcircle.pbm")
#generator.circle(150).write("resources/images/generated/circle_B.pbm")
#generator.function(method(:f)).write("resources/images/generated/e^x_A.pbm")
#generator.line(100, 100, 200, 400).write("resources/images/generated/line_A.pbm")
#generator.rectangle(100, 100, 400, 400).write("resources/images/generated/rectangle_A.pbm")