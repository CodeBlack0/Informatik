require_relative "obj/encrypt"
require 'pnm'

encrypt = Encrypt.new
rsa_alpha = encrypt.rsa_en_alphagen(11, 255)

image1 = PNM.read("resources/pictures/originals/moon_cernan.pgm")
e_pixels1 = image1.pixels.clone.map { |row|  row.map { |pixel| pixel = rsa_alpha[pixel] != nil ? rsa_alpha[pixel] : 0 }}
PNM.create(e_pixels1, {:type => image1.type, :maxgray => image1.maxgray}).write("resources/pictures/edited/moon_cernan_rsa.pgm")

image2 = PNM.read("resources/pictures/originals/kitten.ppm")
e_pixels2 = image2.pixels.clone.map { |row|  row.map { |pixel| pixel.map.with_index { |val, i| pixel[(i == pixel.length - 1 ? 0 : i + 1)] = rsa_alpha[val] != nil ? rsa_alpha[val] : 0 }}}
PNM.create(e_pixels2, {:type => image2.type, :maxgray => image2.maxgray}).write("resources/pictures/edited/kitten_rsa.ppm")
