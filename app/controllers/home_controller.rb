class HomeController < ApplicationController
  before_filter :authenticate_user!, :except =>[:index]
  	
  	def index
    	require 'twitter-korean-text-ruby'
      require 'rubygems'
      require 'mechanize'
      require 'rest-client'
      
      agent = Mechanize.new
      page = agent.get "http://naver.com"
      search_form = page.form_with :name => "sform"
      search_form.field_with(:name=>"query").value = "어린이 젤리"
      search_results = agent.submit search_form
      main_uri = search_results.uri

      agent = Mechanize.new
      blog_uri = agent.get(main_uri)
      page = agent.page.link_with(:text => '블로그').click

      html = agent.get(page.uri).body
      html_doc = Nokogiri::HTML(html)
      blog_section = html_doc.css('ul#elThumbnailResultArea.type01')
      @blog_head = blog_section.css('dt').css('a')
      @blog_content = blog_section.css('dd.sh_blog_passage')
      @blog_date = blog_section.css('dd.txt_inline')
      @all_content = []
  end
end
