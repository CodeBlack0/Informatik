# numberlist_sort_test.rb: Unit tests for the NumberList class.
#
# Copyright (C) 2012-2016 Marcus Stollsteimer

require "minitest/autorun"

require_relative "numberlist"

describe NumberList do

  before do
    @testdata     = [4, 1, 8, 4, 3, 4, 6, 4]
    @testdata_str = "4 1 8 4 3 4 6 4"
    @list = NumberList.new(@testdata)
  end

  it "can return a sorted NumberList object with #selection_sort" do
    @list.selection_sort.class.must_equal NumberList
    @list.selection_sort.to_a.must_equal @testdata.sort
  end

  it "is not modified by the method #selection_sort" do
    before = @list.to_a.dup
    @list.selection_sort
    @list.to_a.must_equal before
  end

  it "can return a sorted NumberList object with #bubble_sort" do
    @list.bubble_sort.class.must_equal NumberList
    @list.bubble_sort.to_a.must_equal @testdata.sort
  end

  it "is not modified by the method #bubble_sort" do
    before = @list.to_a.dup
    @list.bubble_sort
    @list.to_a.must_equal before
  end

  it "can return a sorted NumberList object with #quick_sort" do
    @list.quick_sort.class.must_equal NumberList
    @list.quick_sort.to_a.must_equal @testdata.sort
  end

  it "is not modified by the method #quick_sort" do
    before = @list.to_a.dup
    @list.quick_sort
    @list.to_a.must_equal before
  end
end
