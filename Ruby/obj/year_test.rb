# year_test.rb: Unit tests for the Year class.
#
# Copyright (C) 2012-2016 Marcus Stollsteimer

require "minitest/autorun"

require_relative "year"

describe Year do

  before do
    @year = Year.new(2012)
  end

  it "does not give read or write access to its instance variables" do
    @year.instance_variables.each do |var|
      reader = "#{var}".gsub(/\A@/, "").to_sym
      writer = "#{var}=".gsub(/\A@/, "").to_sym
      lambda { @year.send reader }.must_raise NoMethodError
      lambda { @year.send writer, 2000 }.must_raise NoMethodError
    end
  end

  it "can return the year as string" do
    @year.to_s.must_equal "2012"
  end

  it "knows whether it is a leap year (400 year rule)" do
    data = {
      1600 => true,
      2000 => true,
      2400 => true
    }
    data.each do |year, expected|
      Year.new(year).leap?.must_equal expected
    end
  end

  it "knows whether it is a leap year (100 year rule)" do
    data = {
      1700 => false,
      1800 => false,
      1900 => false,
      2100 => false,
      2200 => false,
      2300 => false
    }
    data.each do |year, expected|
      Year.new(year).leap?.must_equal expected
    end
  end

  it "knows whether it is a leap year (4 year rule)" do
    data = {
      1996 => true,
      1997 => false,
      1998 => false,
      1999 => false,
      2001 => false,
      2002 => false,
      2003 => false,
      2004 => true,
      2008 => true
    }
    data.each do |year, expected|
      Year.new(year).leap?.must_equal expected
    end
  end
end
