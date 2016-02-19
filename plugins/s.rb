#!/usr/bin/env ruby

require "rubygems"
require "json"
require "yahoofinance"

define_plugin("!s") do |msg|
  quotes = YahooFinance::get_standard_quotes(msg)
  string = quotes.map do |symbol, quote|
    "#{symbol}: last #{quote.lastTrade}, change #{quote.change}, range #{quote.dayRange}"
  end.join(";  ")
  reply(string)
end
