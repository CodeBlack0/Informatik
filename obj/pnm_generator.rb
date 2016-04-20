class PNMGenerator
  attr_accessor :height, :width, :x_offset, :y_offset, :density

  def initialize opt = {}  #h = 100, w = 100, x = w / 2, y = h / 2, d = [h,w].max / 2
    @height =   opt[:height]   || opt[:h] || 100
    @width =    opt[:width]    || opt[:w] || 100
    @x_offset = opt[:x_offset] || opt[:x] || @width / 2
    @y_offset = opt[:y_offset] || opt[:y] || @height / 2
    @density =  opt[:density]  || opt[:d] || [@height, @width].max / 2
  end
  
  #takes a mathimatical function and plots it to a pbm file ------------------------------------------------
  def function(function, opt={})
  	axis = opt[:axis] || opt[:a] || :off
		pixels = []
	  
		@width.times do |x|
			row = Array.new(@height, nil)
	
			@height.times do |y|
			  pixel = 0
			  @density.times do |i|
			    xx = (x + i.to_f/@density) - @x_offset
			    yy = function.call(xx) + @y_offset
			    if yy >= y && yy < y + 1
		 	      pixel = 1
		 	      break
		 	    else
		 	    	next
		 	    end
		    end
		    row[y] = pixel
		  end
		  pixels << row
		end
	
		PNM.create(pixels.transpose.reverse!, {:type => :pbm})
  end
  
  #make rectangle between two points -----------------------------------------------------------------------
  def rectangle(x1, y1, x2, y2)
  	return nil if x1 > x2 || y1 > y2 || x1 < 0 || y1 < 0 || x2 > @width || y2 > @height
    pixels = []

    @height.times do |x|
    	row = Array.new(@width, 0)
    	@width.times do |y|
    	  row[y] = y >= y1 && y <= y2 && x >= x1 && x <= x2 ? 1 : 0        
      end
      pixels << row
    end
    
    PNM.create(pixels, {:type => :pbm})
  end
  
  #draws circle around center point ------------------------------------------------------------------------
  def circle(radius)
		pixels = []

		@width.times do |x|
			row = Array.new(@height, nil)
	
			@height.times do |y|
			  pixel = 0
			  @density.times do |i|
			    xx = (x + i.to_f/@density) - @x_offset
			    yy = f_halfcircle(xx, radius)
          yt = yy + @y_offset
          yb = -yy + @y_offset

			    if (yt >= y && yt < y + 1) || (yb >= y && yb < y + 1)
		 	      pixel = 1
		 	    end
		    end
		    row[y] = pixel
		  end
		  pixels << row
		end
	
		PNM.create(pixels.transpose.reverse!, {:type => :pbm})
  end
  
  #draw line between two points ----------------------------------------------------------------------------
  def line(xx1, yy1, xx2, yy2)
  	return "some y out of range" unless (0..@height-1).include?(yy1) && (0..@height-1).include?(yy2) 
  	return "some x out of range" unless (0..@width-1).include?(xx1) && (0..@width-1).include?(xx2)

    x1 = [xx1, xx2].min
    x2 = [xx1, xx2].max
    y1 = [yy1, yy2].min
    y2 = [yy1, yy2].max

    m = (y2 - y1) / (x2 - x1)
    b = y2 - m * x2
    pixels = Array.new(@width, Array.new(@height, 0))

    (x1..x2).each do |x|
    	column = Array.new(@height, 0)
      (y1..y2).each do |y|
      	pixel = 0
        @density.times do |i|
        	xx = (x + i.to_f / @density)
        	yy = m * xx + b
          pixel = 1 if yy >= y && yy < y + 1
          break if pixel != 0
        end
        column[y] = pixel
      end
      pixels[x] = column
    end

    PNM.create(pixels.transpose, {:type => :pbm})
  end
  
  private
  #math functions for internal use -------------------------------------------------------------------------
  def f_halfcircle(x, radius)
		if x >= -radius && x <= radius
	    return Math.sqrt(radius ** 2 - x ** 2)
	  else
	    return @height + 1
	  end
  end
end