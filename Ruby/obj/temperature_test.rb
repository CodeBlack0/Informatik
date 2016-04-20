# temperature_test.rb: Unit tests for the Temperature class.
#
# Copyright (C) 2012-2015 Marcus Stollsteimer

require "minitest/autorun"

require_relative "temperature"

describe Temperature do

  it "can be created with a given Celsius temperature" do
    Temperature.new(0)
  end

  it "has a default value of 0 degree Celsius" do
    Temperature.new.celsius.must_equal 0
  end

  it "can return the temperature as degree Celsius" do
    Temperature.new(0).celsius.must_equal 0
  end

  it "can return the temperature as degree Fahrenheit" do
    Temperature.new(0).fahrenheit.must_equal 32
  end

  it "sets fahrenheit correctly when changing celsius" do
    temp = Temperature.new(0)
    temp.celsius = 20
    temp.celsius.must_equal 20
    temp.fahrenheit.must_equal 68
  end

  it "sets celsius correctly when changing fahrenheit" do
    temp = Temperature.new(0)
    temp.fahrenheit = 5
    temp.fahrenheit.must_be_within_delta 5
    temp.celsius.must_be_within_delta(-15)
  end

  it "calculates temperatures correctly" do
    celsius    = [ 0, -17.7778, 10, 37.7778,    42, 100]
    fahrenheit = [32,        0, 50,     100, 107.6, 212]

    celsius.each_index do |index|
      temp_c = celsius[index]
      temp_f = fahrenheit[index]

      celsius_temp = Temperature.new(temp_c)
      celsius_temp.fahrenheit.must_be_within_delta(temp_f)

      fahrenheit_temp = Temperature.new
      fahrenheit_temp.fahrenheit = temp_f
      fahrenheit_temp.celsius.must_be_within_delta(temp_c)
    end
  end
end
