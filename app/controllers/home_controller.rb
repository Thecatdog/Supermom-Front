class HomeController < ApplicationController
  before_filter :authenticate_user!, :except =>[:index]
    def index1
      if params[:choose_categories].nil?
        @categories = ""
      else
        @categories = params[:choose_categories]
      end
      @categories_array = ["건강","교육","도서","생활용품","장난감","음식","여행","패션"]
    end
    
  	def index
  	  require '~/workspace/lib/naver_crawler.rb'
    	require 'twitter-korean-text-ruby'
    	@test =  Naver_crawler.new
    # 	@search_doll = @test.blog_search("인형")
    # # 	@test.get_title_s_content(@search_doll, 5)
    # @test.body_of_blog
  end
end
