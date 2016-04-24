require "pnm"
require_relative 'obj/pnm_converter.rb'
require_relative 'obj/pnm_generator.rb'
require_relative 'obj/pnm_draw.rb'

#converter = PNMConverter.new
#generator = PNMGenerator.new({:h => 144, :w => 192, :d => 50})
draw = PNMDraw.new
#
#def f(x)
#  Math::E ** (0.01 * x)
#end

$rounding_factor = 4

def line(p1, p2)

  x1 = [p1[0], p2[0]].min
  x2 = [p1[0], p2[0]].max
  y1 = [p1[1], p2[1]].min
  y2 = [p1[1], p2[1]].max

  m = (y2.to_f - y1) / (x2 - x1)
  b = y2 - m * x2
  f = {}

  (x1..x2).each do |x|
    f[x] = (m * x + b).round($rounding_factor)
  end

  f
end

a = [130, 100]
b = [100,  50]
c = [170, 110]
#d = [180, 140]

image = PNM.read("resources/images/originals/kitten.ppm")
#bwmap = PNM.read("resources/images/generated/circle_C.pbm")
#draw.pbm_onto_image(image, bwmap, {:color => [255, 0, 255]}).write("resources/images/edited/kitten_circle.ppm")
#draw.fill_area4(image, a, b, c, d, {:c => [0,255,255]}).write("resources/images/edited/kitten_test_fill_area_2.ppm")

#converter.blur(image, 3).write("resources/images/edited/rectangle_A_b3.pgm")
#converter.add(image, image2).write("resources/images/generated/circle_A_+_halfcircle.pbm")

#generator.circle(50).write("resources/images/generated/circle_C.pbm")
#generator.function(method(:f)).write("resources/images/generated/e^x_A.pbm")
#generator.line(0, 0, 192, 144).write("resources/images/generated/line_A.pbm")
#image2 = generator.function(method(:f))
#generator.rectangle(100, 100, 400, 400).write("resources/images/generated/rectangle_A.pbm")


def line(p1, p2)  
  x1 = [p1[0], p2[0]].min
  x2 = [p1[0], p2[0]].max
  y1 = [p1[1], p2[1]].min
  y2 = [p1[1], p2[1]].max

  m = (y2.to_f - y1) / (x2 - x1)
  b = y2 - m * x2
  f = {}

  (x1..x2).each do |x|
    f[x] = (m * x + b).round($rounding_factor)
  end

  f
end


