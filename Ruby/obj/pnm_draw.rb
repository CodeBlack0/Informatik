require 'pnm'
require_relative 'pnm_generator'

class PNMDraw

  def initialize()
    @generator = PNMGenerator.new
  end

  def line(canvas, pt1, pt2, opt={})
  	color = opt[:color] || opt[:c]
  	color = canvas.type == :ppm ? [canvas.maxgray, canvas.maxgray, canvas.maxgray] : canvas.type == :pgm ? canvas.maxgray : 1 unless opt.has_key?(:color) || opt.has_key?(:c)

  	@generator.parse_options({:h => canvas.height, :w => canvas.width, :d => 50})
    line = @generator.line(pt1[0], pt1[1], pt2[0], pt2[1]).pixels.dup  	
    original = canvas.pixels.dup
    
    edited = original.map.with_index { |row, y| row.map.with_index { |pixel, x| (line[y][x] == 1) ? color : pixel}}
    return PNM.create(edited, {:type => canvas.type, :maxgray => canvas.maxgray})
  end

  def pbm_onto_image(canvas, map, opt={})
  	return "map not pbm" if map.type != :pbm
  	color = opt[:color] || opt[:c]
  	color = canvas.type == :ppm ? [canvas.maxgray, canvas.maxgray, canvas.maxgray] : canvas.type == :pgm ? canvas.maxgray : 1 unless opt.has_key?(:color) || opt.has_key?(:c)
    
    bwmap = map.pixels.dup  	
    original = canvas.pixels.dup

    edited = original.map.with_index { |row, y| row.map.with_index { |pixel, x| (bwmap[y][x] == 1) ? color : pixel}}
    return PNM.create(edited, {:type => canvas.type, :maxgray => canvas.maxgray})
  end
  
  def fill_area(canvas, pt1, pt2, pt3, pt4, opt={})
    color = opt[:color] || opt[:c]
    color = canvas.type == :ppm ? [canvas.maxgray, canvas.maxgray, canvas.maxgray] : canvas.type == :pgm ? canvas.maxgray : 1 unless opt.has_key?(:color) || opt.has_key?(:c)
    
    ab = line(pt1, pt2)
    ad = line(pt1, pt4)
    sum_a = ab.merge(ad)
    cb = line(pt3, pt2)
    cd = line(pt3, pt4)
    sum_c = cb.merge(cd)
    
    final = []
    canvas.height.times do |y|
    	row = []
      canvas.width.times do |x|
        pixel = canvas.pixels[y][x]
      	if (sum_a.has_key?(x) && sum_c.has_key?(x)) && !(y >= sum_a[x] || y <= sum_c[x])
        	pixel = color
        end
        row << pixel
      end
      final << row
    end
    
    PNM.create(final, {:type => :ppm, :maxgray => 255})
  end

  private
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
end