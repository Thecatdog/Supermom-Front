class HomeController < ApplicationController
  before_filter :authenticate_user!, :except =>[:index]
    def index1
      @categories = params[:choose_categories]
      @categories_array = ["건강","교육","도서","생활용품","장난감","음식","여행","패션"]
    end
    
  	def index
    	require 'twitter-korean-text-ruby'
  end
end
