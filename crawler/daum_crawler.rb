
# daum form_name : daumSearch
	 # input : q
# name form_name : sfrom
	 # input : query 

require 'rubygems'
require 'mechanize'
require 'rest-client'

# main가져오기
agent = Mechanize.new
page = agent.get "http://daum.net"

page = page.form_with :name => "daumSearch"
page.field_with(:name=>"q").value = "유모차"
search_results = agent.submit page
# puts search_results.uri

# 메인에서 블로그 이동
# page = agent.page.link_with(:text => '블로그').click
