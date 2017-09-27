
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

# 5번 시작
blog_link_uri = blog_head[6].attr('href')

puts blog_link_uri

blog_link_uri = blog_link_uri.gsub("http://", "http://m.")
page  = agent.get(blog_link_uri)
tag = page.search('div.post_tag')
puts tag.text
# 5번완료 
