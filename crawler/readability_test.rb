require 'rubygems'
require 'readability'
require 'open-uri'

source = open('http://lab.arc90.com/experiments/readability/').read
puts Readability::Document.new(source).content