require "pnm"

class PNMConverter
  @@channels = ['r', 'g', 'b']

  # Returns a copy of the image ----------------------------------------------------------------------------
  def copy(image)
    type    = image.type
    maxgray = image.maxgray
    pixels  = image.pixels

    PNM.create(pixels, {:type => type, :maxgray => maxgray})
  end
  
  #flip vertically -----------------------------------------------------------------------------------------
  def vflip(image)
    vflipped = image.pixels.dup.reverse
    return PNM.create(vflipped, {:type => image.type, :maxgray => image.maxgray})
  end

  #flip horizontally ---------------------------------------------------------------------------------------
  def hflip(image)
    hflipped = image.pixels.dup.map {|row| row.reverse }
    return PNM.create(hflipped, {:type => image.type, :maxgray => image.maxgray})
  end
  
  #invert colorspace ---------------------------------------------------------------------------------------
  def invert(image)    
    inverted = image.pixels.dup.
      map { |row| row.
      map { |pixel| image.type == :ppm ? pixel.map { |val| image.maxgray - val } : image.maxgray - pixel}}
    
    return PNM.create(inverted, {:type => image.type, :maxgray => image.maxgray})    
  end
  
  #rotate 90° clockwise ------------------------------------------------------------------------------------
  def rotate(image)
    rotated = image.pixels.dup.transpose.map { |row| row.reverse }
    PNM.create(rotated, {:type => image.type, :maxgray => image.maxgray})
  end

  #rotate 90° conterclockwise ------------------------------------------------------------------------------
  def rotate_c(image)
    rotated = image.pixels.dup.transpose.reverse
    PNM.create(rotated, {:type => image.type, :maxgray => image.maxgray})
  end
  
  #highten contrast to the power of i ----------------------------------------------------------------------
  def highten_contrast(image, i = 2)
    edited = image.pixels.dup.
      map { |row| row.
      map { |pixel|  ((pixel.to_f/image.maxgray)**i * image.maxgray).to_i }} if image.type == :pgm

    edited = image.pixels.dup.
      map { |row| row.
      map { |pixel| pixel.
      map { |val| ((val.to_f/image.maxgray)**i * image.maxgray).to_i }}} if image.type == :ppm
    
    edited = image.pixels if image.type == :pbm

    PNM.create(edited, {:type => image.type, :maxgray => image.maxgray})  
  end
  
  #lower contrast to the power of 1/i ----------------------------------------------------------------------
  def lower_contrast(image, i = 2)
    edited = image.pixels.dup.
      map { |row| row.
      map { |pixel|  ((pixel.to_f/image.maxgray)**(1.0/i) * image.maxgray).to_i }} if image.type == :pgm

    edited = image.pixels.dup.
      map { |row| row.
      map { |pixel| pixel.
      map { |val| ((val.to_f/image.maxgray)**(1.0/i) * image.maxgray).to_i }}} if image.type == :ppm

    edited = image.pixels if image.type == :pbm

    PNM.create(edited, {:type => image.type, :maxgray => image.maxgray}) 
  end

  #get single channel from color image ---------------------------------------------------------------------
  def channel(image, channel)
    return image if not @@channels.include? channel or image.type != :ppm

    channeled = image.pixels.dup.
        map { |row| row.
        map { |pixel| pixel.
        map.with_index { |val, i| val = i == @@channels.index(channel) ? val : 0}}}

    PNM.create(channeled, {:type => image.type, :maxgray => image.maxgray})
  end
  
  #get all channel from color image ------------------------------------------------------------------------
  def channel_split(image)
    return image if image.type != :ppm

    r, g, b = [], [], []
    image.height.times do |y|
      r[y], g[y], b[y] = [], [], []
      image.width.times do |x|
        r[y][x] = image.pixels[y][x][0]
        g[y][x] = image.pixels[y][x][1]
        b[y][x] = image.pixels[y][x][2] 
      end
    end

    rim = PNM.create(r, {:type => :pgm, :maxgray => image.maxgray})
    gim = PNM.create(g, {:type => :pgm, :maxgray => image.maxgray})
    bim = PNM.create(b, {:type => :pgm, :maxgray => image.maxgray})
    return rim, gim, bim
  end
  
  #combine differnt channels into color image --------------------------------------------------------------
  def channel_combine(r, g, b)
    return image if r.width != g.width or r.height != b.height or \
                    r.width != g.width or r.width != b.width or \
                    r.type != :pgm or b.type != :pgm or  g.type != :pgm

    mixed = []
    r.pixels.size.times do |y|
      mixed[y] = []
      r.pixels[0].size.times do |x|
        mixed[y][x] = [r.pixels[y][x], g.pixels[y][x], b.pixels[y][x]]
      end
    end

    PNM.create(mixed, {:type => :ppm, :maxgray => [r.maxgray, g.maxgray, b.maxgray].max })
  end
  
  #convert color to grayscale image through pixel average --------------------------------------------------
  def color_to_grayscale(image)
    return image if image.type != :ppm

    converted = image.pixels.dup.
      map { |row| row.
      map { |pixel| pixel = ((pixel[0] + pixel[1] + pixel[2]) / 3).round }}

    PNM.create(converted, {:type => :pgm, :maxgray => image.maxgray })
  end
  
  #extract luminance data from color image -----------------------------------------------------------------
  def color_to_luminance(image)
    return image if image.type != :ppm
    
    converted = image.pixels.dup.
      map { |row| row.
      map { |pixel| pixel = ( 0.3 * pixel[0] + 0.59 * pixel[1] + 0.11 * pixel[2]).round}}
    
    PNM.create(converted, {:type => :pgm, :maxgray => 255 })
  end

  #blurring image ------------------------------------------------------------------------------------------
  def blur(image, radius = 1)
    original = image.pixels.dup
    blurred = []
    type = image.type == :pbm ? :pgm : image.type
    maxgray = image.type == :pbm ? 255 : image.maxgray

    original.each_with_index do |row, y| 
      blurred[y] = []
      row.length.times do |x|
        #limit bounding box to values inside auf the pixel array
        y_min = y > radius - 1 ? y - radius : 0
        y_max = y < original.length - radius + 1 ? y + radius : original.length
        x_min = x > radius - 1 ? x - radius : 0
        x_max = x < row.length - radius + 1 ? x + radius : row.length

        #get bounding box
        bb = original[(y_min)..(y_max)]
        bb.map! { |row| row = row[(x_min)..(x_max)] }

        if image.type == :pgm # -------------------------------------
          #average bb
          bb.flatten!  
          pixel = (bb.reduce(:+).to_f / bb.size).round

        elsif image.type == :ppm # ----------------------------------
          #spliting bb in different colors
          r_bb = bb.map { |row| row.map { |pixel| pixel = pixel[0] }}
          r_bb.flatten!
          g_bb = bb.map { |row| row.map { |pixel| pixel = pixel[1] }}
          g_bb.flatten!
          b_bb = bb.map { |row| row.map { |pixel| pixel = pixel[2] }}         
          b_bb.flatten!

          #average bb in r, g, and b
          r = (r_bb.reduce(:+).to_f / r_bb.size).round
          g = (g_bb.reduce(:+).to_f / g_bb.size).round
          b = (b_bb.reduce(:+).to_f / b_bb.size).round

          #composit color pixel
          pixel = [r, g, b]

        elsif image.type == :pbm # ----------------------------------
          #average b&w bb to grayscale value
          bb.flatten!
          bb.map! { |pixel| pixel = pixel == 1 ? 0 : 255 }
          pixel = (bb.reduce(:+).to_f / bb.size).round
        end
        
        #add pixel to output pixel array
        blurred[y][x] = pixel        
      end
    end
    return PNM.create(blurred, {:type => type, :maxgray => maxgray})
  end

  #generate histogram hash from input imgae values --------------------------------------------------------.
  def generate_histogram_hash(image)
    return {} if image.type == :pbm
    original = image.pixels.dup.flatten 

    #counting number of pixels per frequency
    freq = Hash.new 0
    original.map { |pixel| freq[pixel] += 1}
    
    freq
  end

  #generate histogram image from input imgae values --------------------------------------------------------
  def generate_histogram(image)
    return image if image.type == :pbm
    
    #getting histogram hash
    freq = generate_histogram_hash(image)
    
    #changing number of pixels per frequency to percent of max number of pixels per frequency
    per_freq = 100.0 / freq.values.max
    freq.each { |k, v| freq[k] = (v.to_f * per_freq).round }
    
    #filling histogram horizontally
    histogram_frame = Array.new(image.maxgray, Array.new(100, 1))
    histogram = histogram_frame.map.with_index { |row, cur_freq| row.
                                map.with_index { |pixel, i| i >= freq[cur_freq] ? 0 : 1 }}
    
    #returning proper histogram (90° Counterclockwise Rotation)
    PNM.create(histogram.transpose.reverse!, {:type => :pbm})
  end

  #generate histogram equalized image from input image -----------------------------------------------------
  #based on (http://www.tutorialspoint.com/dip/histogram_equalization.htm)
  def histogram_equalize(image)
    return image if image.type == :pbm
    
    #getting histogram hash
    freq = generate_histogram_hash(image)
    pixel_count = image.pixels.dup.flatten.size
    
    #calculate PMF (probability mass function) for histogram values
    pmf = Hash.new 0
    freq.each { |k, v| pmf[k] = v.to_f / pixel_count }

    #calculate CDF (cumulative distributive function) for PMF values
    cdf = Hash.new 0
    tmp = 0.0
    Hash[pmf.sort].each do |k, v|
      tmp += v
      cdf[k] = tmp
    end

    #calculate equalized gray map from CDF
    gray_map = Hash.new 0
    cdf.each { |k, v| gray_map[k] = (v * (image.maxgray - 1)).to_i }

    #applying equalized gray map
    original = image.pixels.dup
    equalized = original.map { |row| row.
                         map { |pixel| gray_map[pixel] }} if image.type == :pgm
    equalized = original.map { |row| row.
                         map { |pixel| pixel.
                         map { |val| gray_map[val] }}} if image.type == :ppm
    
    PNM.create(equalized, {:type => image.type, :maxgray => image.maxgray})
  end

  #clamp pixel values to a certain range -------------------------------------------------------------------
  def clamp(image, bottom, top)
    return image if image.type == :pbm || bottom < 0 || top > image.maxgray

    clamped = image.pixels.dup.map { |row| row.
                               map { |pixel| pixel > top ? top : pixel < bottom ? bottom : pixel }} if image.type == :pgm
    clamped = image.pixels.dup.map { |row| row.
                               map { |pixel| pixel.
                               map { |val| val > top ? top : val < bottom ? bottom : val }}} if image.type == :ppm
  
    PNM.create(clamped, {:type => image.type, :maxgray => image.maxgray})
  end

  #adds images together to make a steganogram --------------------------------------------------------------
  def make_steganogram(image, message)
    return image if image.type == :pbm || message.type != :pbm

    tmp = tmp.type == :ppm ? converter.color_to_grayscale(image) : image
    original = tmp.pixels.dup[0..message.height].map { |row| row[0..message.width] }
    message_map = message.pixels.dup

    steganogram = original.map.with_index { |row, y| row.
                           map.with_index { |pixel, x| if message_map[y][x] == 1
                                                         pixel = pixel + 1 if pixel % 2 == 0
                                                         pixel = pixel if pixel % 2 != 0
                                                       else
                                                         pixel = pixel + 1 if pixel % 2 != 0 && pixel < image.maxgray 
                                                         pixel = pixel - 1 if pixel % 2 != 0 && pixel == image.maxgray
                                                         pixel = pixel if pixel % 2 == 0
                                                       end }}

    PNM.create(steganogram, {:type => :pgm, :maxgray => image.maxgray})
  end
  
  #extracts hidden message from steganogram ----------------------------------------------------------------
  def extract_steganogram(image)
    return image if image.type != :pgm

    steganogram = image.pixels.dup
    
    message = steganogram.map { |row| row.
                          map { |pixel| pixel % 2 == 0 ? 0 : 1}}
    
    PNM.create(message, {:type => :pbm})
  end

  #composits images together (additiv) ---------------------------------------------------------------------
  def add(image1, image2)

    #additive layering of binary images
    if image1.type == :pbm && image2.type == :pbm
      pixels1 = image1.pixels.dup
      pixels2 = image2.pixels.dup
      min_height = [image1.height, image2.height].min
      min_width = [image1.width, image2.width].min
      final = []

      min_height.times do |y|
        row = []
        min_width.times do |x|
          if pixels1[y][x] == 1 || pixels2[y][x] == 1
            row << 1
          else 
            row << 0
          end
        end
        final << row
      end
      PNM.create(final, {:type => :pbm})
    end
  end
end