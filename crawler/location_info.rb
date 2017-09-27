
# -----------------------------------------

# THIS FILE IS ONLY FOR TEST. DO NOT USE AND EDIT IT.
# final_test로 메인 controller에서 사용하지 마시오. 
# 테스트용이므로 이 파일을 수정하지도 말기 

# location_info.rb는 달력에 issue들을 표시 하기 위함
# 이때, '축제' '베이비페어' '교육박람회' 정보를 얻는다

# -----------------------------------------

require 'rubygems'
require 'mechanize'
require 'rest-client'

search_arr = ['축제', '베이비페어']

search_arr.each do | search |
	agent = Mechanize.new
	page = agent.get "http://naver.com"
	search_form = page.form_with :name => "sform"
	search_form.field_with(:name=>"query").value = search
	search_results = agent.submit search_form
	main_uri = search_results.uri

	html = agent.get(main_uri).body
	html_doc = Nokogiri::HTML(html)
	
	html_doc.css('span.tit_box').css('span.date').each do |t|
  		puts t.text.slice!(0...10)
  	end	

  	if search.eql?('축제')
	  	html_doc.css('h5').each do |t|
	  		puts t.text
	  	end
	else
		html_doc.css('h6').each do |t|
	  		puts t.text
	  	end
	end
end
