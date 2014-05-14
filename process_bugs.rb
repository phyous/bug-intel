require 'rubygems'
$:.unshift File.dirname(__FILE__)
require 'analysis'

analysis = Analysis.new(ARGV[0])

keywords = ["photo"]
analysis.analyze_keyword_occurences(keywords)
