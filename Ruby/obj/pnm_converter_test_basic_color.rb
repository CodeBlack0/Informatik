# pnm_converter_test_basic_color.rb: Unit tests for the PNMConverter class.
#
# Copyright (C) 2014-2016 Marcus Stollsteimer

require "minitest/autorun"

require_relative "pnm_converter"

describe PNMConverter do

  before do
    @converter = PNMConverter.new

    col1, col2, col3, col4 = [0,0,0],    [0,5,10], [0,5,0],   [2,4,6]
    col5, col6, col7, col8 = [10,10,10], [10,5,0], [10,5,10], [8,6,4]

    @color_pixels = [[col1, col2, col3], [col2, col4, col6]]
    @color_image = PNM.create(@color_pixels, {:maxgray => 10})

    @color_pixels_invert = [[col5, col6, col7], [col6, col8, col2]]
  end

  it "can invert a color image" do
    @converter.invert(@color_image).pixels.must_equal @color_pixels_invert
  end

  it "can invert a color image without changing the original image" do
    @converter.invert(@color_image)
    @color_image.pixels.must_equal @color_pixels
  end
end
