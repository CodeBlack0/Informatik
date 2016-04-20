# pnm_converter_test.rb: Run all unit tests for the PNMConverter class.
#
# Copyright (C) 2014-2016 Marcus Stollsteimer

gem "pnm", ">= 0.5.0"

Dir["pnm_converter_test_*.rb"].each {|test| require_relative test }
