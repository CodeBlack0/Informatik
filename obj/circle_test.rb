# circle_test.rb: Unit tests for the Circle class.
#
# Copyright (C) 2014-2015 Marcus Stollsteimer

require "minitest/autorun"

require_relative "circle"

describe Circle do

  before do
    @circle = Circle.new(5)
  end

  it "can return its radius" do
    @circle.radius.must_equal 5
  end

  it "can set its radius" do
    @circle.radius = 10
    @circle.radius.must_equal 10
  end

  it "can return its area" do
    @circle.area.must_be_within_delta 78.5398, 0.0001
  end

  it "can set its area" do
    skip
    @circle.area = 42
    @circle.area.must_be_within_delta 42
    @circle.radius.must_be_within_delta 3.6564, 0.0001
  end
end
