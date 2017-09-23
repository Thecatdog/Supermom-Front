
# daum form_name : daumSearch
	 # input : q
# name form_name : sfrom
	 # input : query 

require 'rubygems'
require 'mechanize'
require 'rest-client'

# main가져오기
agent = Mechanize.new
page = agent.get "http://naver.com"
search_form = page.form_with :name => "sform"
search_form.field_with(:name=>"query").value = "유모차"
search_results = agent.submit search_form
main_uri = search_results.uri
# puts main_uri

# 메인에서 블로그 이동
page = agent.page.link_with(:text => '블로그').click

# 페이지를 5번째 페이지까지
for i in 2..5

	html = agent.get(page.uri).body
	html_doc = Nokogiri::HTML(html)
	blog_section = html_doc.css('ul#elThumbnailResultArea.type01')
	blog_head = blog_section.css('dt').css('a')
	blog_mini_content = blog_section.css('dd.sh_blog_passage')
	blog_date = blog_section.css('dd.txt_inline')

	# title 10개를 차례대로 뽑기
	blog_head.each_with_index do |v, i|
		puts i
		puts v.attr('title')
	end

	# 소주제 10개를 차례대로 뽑기
	blog_mini_content.each_with_index do |v, i|
		puts i
		puts v.text
	end

	# 이것은 날짜 뽑기 미완성 (본문에서도 가능하므로 일단 보류)
	# blog_date.each_with_index do |v, i|
	# 	puts i
	# 	puts v.first
	# end

	page = agent.page.link_with(:text => '다음페이지').click
end
