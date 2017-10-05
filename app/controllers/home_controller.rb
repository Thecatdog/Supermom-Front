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
    	
    	@test = Naver_cralwer.new
    	@agent = Mechanize.new
    	@agent = @test.keyword_rslt("인형")
    	@test.shift_to_blog(@agent)
    	puts @test
    	
  end
end
