class HomeController < ApplicationController
  def index
  	require 'twitter-korean-text-ruby'
  	
    # 1. input 에 따른 주소가져오기
    # 2. input 결과 창에서 블로그 버튼 눌렀을때로 이동
    # 3. 블로그 결과에서 title, 소제 가져오기
    # 4. 다음 페이지로 넘어가기
    
    # daum form_name : daumSearch
    	 # input : q
    # name form_name : sfrom
    	 # input : query 
    
    require 'rubygems'
    require 'mechanize'
    require 'rest-client'
    
    # 1번 시작
    agent = Mechanize.new
    page = agent.get "http://naver.com"
    search_form = page.form_with :name => "sform"
    search_form.field_with(:name=>"query").value = "떡뻥"
    search_results = agent.submit search_form
    main_uri = search_results.uri
    # puts main_uri
    # 1번 완료
    
    
    # 2번 시작
    agent = Mechanize.new
    blog_uri = agent.get(main_uri)
    page = agent.page.link_with(:text => '블로그').click
    # puts page.uri
    # 2번 완료
    
    # 3번 시작
    html = agent.get(page.uri).body
    html_doc = Nokogiri::HTML(html)
    blog_section = html_doc.css('ul#elThumbnailResultArea.type01')
    @blog_head = blog_section.css('dt').css('a')
    @blog_content = blog_section.css('dd.sh_blog_passage')
    @blog_date = blog_section.css('dd.txt_inline')
    @all_content = []
 
    
	end

end
