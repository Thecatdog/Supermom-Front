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
    search_form.field_with(:name=>"query").value = "유모차"
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
    
    # # title 10개를 차례대로 뽑기
    # blog_head.each_with_index do |v, i|
    # 	puts i
    # 	puts v.attr('title')
    # end
    
    # 소주제 10개를 차례대로 뽑기
    # @blog_content.each_with_index do |v, i|
    # 	puts i
    # 	@all_content = v.text
    # end
    
    # blog_date.each_with_index do |v, i|
    # 	puts i
    # 	puts v.first
    # end
    
    # 3번 완료
    # 카테고리 키워드
  # 	@keyword = "유모차"
  # 	크롤링한 블로그의 본문 content

  #   @keysearch = TwitterKorean::Processor.new
  #   @divide_content = @keysearch.stem(@all_content)
  #   @appear_count=0
  # #   기본 단어 사전 불러오기 (사물명사가 아닌 카테고리와 연관성 없는 감정명사 등을 거르기 위함)
  #   aFile = File.new('public/word.txt','r')
  #   fSize = aFile.stat.size
  #   if aFile
  #       content = aFile.sysread(fSize)
  #   else
  #       puts 'Unable open file'
  #   end
  # #   인코딩 후 불필요한 기호 제거
  #   base = content.to_s.force_encoding("UTF-8")
  #   @base_dic = @keysearch.stem(base)
  #   @base_dic.delete("\",\"")
  #   @base_dic.delete("\"]")
  #   @base_dic.delete("[\"")
  #   @base_dic.delete(";\",\"")
  # # 기본 사전과 마찬가지로 조사 등록 후 제거하기 위함
  #   @josa = ["이","가","께서","의","을","를","에","에게","께","한테","에서","와","과","로","으로","로서","으로서","로써","으로써","보다","랑","이랑","만큼","하고","더러","보고","이다","고","라고","이라고","며","이고","이며","이면","면","아","야","여","이여","이시여","요","은","는","도","만","조차","밖에","뿐","나","이나","깨나","일랑","부터","까지","라고","이라고","라도","이라도","마는","들", "그려", "그래", "손", "이야", "야", "다가", "커녕", "치고", "마다", "서껀", "야말로", "이야말로", "엔들", "이란", "란", "곧", "대로", "따라", "토록", "든지", "이든지", "이라야", "인즉"]
  # # @noun_content = 걸러진 명사를 저장하기 위한 배열
  #   @noun_content = []
  #   @divide_content.each do |s|
  #       @metadata = s.metadata
  #       if @metadata.pos.to_s.include? "noun"
  #           if @josa.include? s
  #           else
  #               @noun_content << s
  #           end
  #       elsif @metadata.pos.to_s.include? "alpha"
  #         @noun_content << s
  #       else
  #       end
  #       if s== @keyword
  #           @appear_count=@appear_count+1
  #       else
  #       end
  #   end
  #   # 기본 사전 단어와 비교해서 포함되어있으면 거르고 아니라면 @complete_fillter_content 배열에 추가
  #   @complete_fillter_content = []
  #   @noun_content.each do |n|
  #     if @base_dic.include? n
  #     else
  #       @complete_fillter_content << n
  #     end
  #   end
    
	end
end
