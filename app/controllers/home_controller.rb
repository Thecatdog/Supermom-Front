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
    	@agent = @test.keyword_rslt("장난감")
    	@test.shift_to_blog(@agent)

    end
    
    def growth
      if current_user.baby_age.eql? ("13m" || "14m")
        if current_user.baby_sex.eql? "남"
          DataBoy.where(baby_age: "12m").each do |b|
            @boyWeight = b.baby_weight
            @boyHeight = b.baby_height
            @boyHeadLength = b.baby_head_length
          end
        else #여
          DataGirl.where(baby_age: "12m").each do |g|
            @girlWeight = g.baby_weight
            @girlHeight = g.baby_height
            @girlHeadLength = g.baby_head_length
          end
        end
      elsif current_user.baby_age.eql? ("16m" || "17m")
        if current_user.baby_sex.eql? "남"
          DataBoy.where(baby_age: "15m").each do |b|
            @boyWeight = b.baby_weight
            @boyHeight = b.baby_height
            @boyHeadLength = b.baby_head_length
          end
        else #여
          DataGirl.where(baby_age: "15m").each do |g|
            @girlWeight = g.baby_weight
            @girlHeight = g.baby_height
            @girlHeadLength = g.baby_head_length
          end
        end
      elsif current_user.baby_age.eql? ("19m" || "20m")
        if current_user.baby_sex.eql? "남"
          DataBoy.where(baby_age: "18m").each do |b|
            @boyWeight = b.baby_weight
            @boyHeight = b.baby_height
            @boyHeadLength = b.baby_head_length
          end
        else #여
          DataGirl.where(baby_age: "18m").each do |g|
            @girlWeight = g.baby_weight
            @girlHeight = g.baby_height
            @girlHeadLength = g.baby_head_length
          end
        end  
      elsif current_user.baby_age.eql? ("22m" || "23m")
        if current_user.baby_sex.eql? "남"
          DataBoy.where(baby_age: "21m").each do |b|
            @boyWeight = b.baby_weight
            @boyHeight = b.baby_height
            @boyHeadLength = b.baby_head_length
          end
        else #여
          DataGirl.where(baby_age: "21m").each do |g|
            @girlWeight = g.baby_weight
            @girlHeight = g.baby_height
            @girlHeadLength = g.baby_head_length
          end
        end  
      else
        if current_user.baby_age.include? "m" || current_user.baby_age.to_i < 7
          if current_user.baby_sex.eql? "남"
            DataBoy.where(baby_age: current_user.baby_age).each do |b|
              @boyWeight = b.baby_weight
              @boyHeight = b.baby_height
              @boyHeadLength = b.baby_head_length
            end
          else #여
            DataGirl.where(baby_age: current_user.baby_age).each do |g|
              @girlWeight = g.baby_weight
              @girlHeight = g.baby_height
              @girlHeadLength = g.baby_head_length
            end
          end
        else #7세이상
          if current_user.baby_sex.eql? "남"
            DataBoy.where(baby_age: current_user.baby_age).each do |b|
              @boyWeight = b.baby_weight
              @boyHeight = b.baby_height
            end
          else #여
            DataGirl.where(baby_age: current_user.baby_age).each do |g|
              @girlWeight = g.baby_weight
              @girlHeight = g.baby_height
            end
          end
        end
      end
      
      if @boyHeight.nil?
        @resultHeight = @girlHeight
      else
        @resultHeight = @boyHeight
      end
      
      if @boyWeight.nil?  
        @resultWeight = @girlWeight
      else
        @resultWeight = @boyWeight
      end
      
      if @boyHeadLength.nil? && @girlHeadLength.nil?

      elsif @boyHeadLength.nil?   
        @resultHeadLength = @girlHeadLength
      else
        @resultHeadLength = @boyHeadLength
      end
      
    end
    
    def edit
      @user = User.find(params[:user_id])
      @user.name = params[:name]
      @user.email = params[:email]
      @user.address = params[:address]
      @user.baby_name = params[:baby_name]
      @user.baby_sex = params[:baby_sex]
      @user.baby_age = params[:baby_age]
      @user.baby_height = params[:baby_height]
      @user.baby_weight = params[:baby_weight]
      @user.baby_head_length = params[:baby_head_length]
      @user.save
      redirect_to '/'
    end
end
