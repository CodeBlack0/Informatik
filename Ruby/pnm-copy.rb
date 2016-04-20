USAGE = "Usage: pnm-copy.rb file"
abort USAGE  unless ARGV.size == 1

require_relative "obj/pnm_converter"

converter = PNMConverter.new

infile = ARGV.shift
name = infile.rpartition(".").first
outfile = "#{name}-copy"

image = PNM.read(infile)
new_image = converter.copy(image)
new_image.write_with_extension(outfile)