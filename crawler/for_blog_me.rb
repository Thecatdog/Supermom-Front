
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

# 5번 시작
blog_link_uri = blog_head[7].attr('href')
html = agent.get(blog_link_uri)
second_uri = html.search('frame').attr('src')
page = agent.get(second_uri)
page = page.search('frame').attr('src')
uri = "http://m.blog.naver.com" + page
# puts uri

page = agent.get(uri)
tag = page.search('div.post_tag')
puts tag.text
# 5번완료 
