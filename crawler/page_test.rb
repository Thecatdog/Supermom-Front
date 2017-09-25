
# 1. input 에 따른 주소가져오기
# 2. input 결과 창에서 블로그 버튼 눌렀을때로 이동
# 3. 블로그 결과에서 title, 소제 가져오기
# 4. 다음 페이지로 넘어가기
# 5. 링크로 들어가서 큰 content
# 6. readability

# daum form_name : daumSearch
	 # input : q
# name form_name : sfrom
	 # input : query 

require 'rubygems'
require 'mechanize'
require 'rest-client'
require 'readability'

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
# 2번 완료

# 3번 시작
html = agent.get(page.uri).body
html_doc = Nokogiri::HTML(html)
blog_section = html_doc.css('ul#elThumbnailResultArea.type01')
blog_head = blog_section.css('dt').css('a')
# blog_content = blog_section.css('dd.sh_blog_passage')
# blog_date = blog_section.css('dd.txt_inline')


# title 10개를 차례대로 뽑기
# blog_head.each_with_index do |v, i|
# 	puts i
# 	puts v.attr('title')
# end

# 소주제 10개를 차례대로 뽑기
# blog_content.each_with_index do |v, i|
# 	puts i
# 	puts v.text
# end

# blog_date.each_with_index do |v, i|
# 	puts i
# 	puts v.first
# end
# 3번 완료

# 4번 시작
# for i in 2..5
#     page = agent.page.link_with(:text => '다음페이지').click
# 	puts page.uri
# end

# 5번 시작
blog_link_uri = blog_head[0].attr('href')
blog_link_uri = blog_link_uri.gsub("http://", "http://m.")
page  = agent.get(blog_link_uri)
tag = page.search('div.post_tag')
puts tag.text

# 5번완료 
