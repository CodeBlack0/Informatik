# pnm_converter_test_basic.rb: Unit tests for the PNMConverter class.
#
# Copyright (C) 2014-2016 Marcus Stollsteimer

require "minitest/autorun"

require_relative "pnm_converter"

describe PNMConverter do

  before do
    @converter = PNMConverter.new

    @pixels = [[0,2,4], [1,3,5]]
    @image = PNM.create(@pixels, {:maxgray => 5})

    @pixels_copy = [[0,2,4], [1,3,5]]
    @pixels_vflip = [[1,3,5], [0,2,4]]
    @pixels_hflip = [[4,2,0], [5,3,1]]
    @pixels_invert = [[5,3,1], [4,2,0]]
    @pixels_rotate = [[1,0], [3,2], [5,4]]

    @bw_pixels = [[1,0,1], [1,1,0]]
    @bw_image = PNM.create(@bw_pixels)

    @bw_pixels_invert = [[0,1,0], [0,0,1]]
  end

  it "can copy an image" do
    @converter.copy(@image).pixels.must_equal @pixels_copy
  end

  it "can copy an image without changing the original image" do
    @converter.copy(@image)
    @image.pixels.must_equal @pixels
  end

  it "can flip an image vertically" do
    @converter.vflip(@image).pixels.must_equal @pixels_vflip
  end

  it "can flip an image vertically without changing the original image" do
    @converter.vflip(@image)
    @image.pixels.must_equal @pixels
  end

  it "can flip an image horizontally" do
    @converter.hflip(@image).pixels.must_equal @pixels_hflip
  end

  it "can flip an image horizontally without changing the original image" do
    @converter.hflip(@image)
    @image.pixels.must_equal @pixels
  end

  it "can invert an image" do
    @converter.invert(@image).pixels.must_equal @pixels_invert
  end

  it "can invert an image without changing the original image" do
    @converter.invert(@image)
    @image.pixels.must_equal @pixels
  end

  it "can invert a bilevel image" do
    @converter.invert(@bw_image).pixels.must_equal @bw_pixels_invert
  end

  it "can invert a bilevel image without changing the original image" do
    @converter.invert(@bw_image)
    @bw_image.pixels.must_equal @bw_pixels
  end

  it "can rotate an image clockwise" do
    @converter.rotate(@image).pixels.must_equal @pixels_rotate
  end

  it "can rotate an image without changing the original image" do
    @converter.rotate(@image)
    @image.pixels.must_equal @pixels
  end
end
