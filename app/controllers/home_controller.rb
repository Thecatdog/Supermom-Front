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

      category = Category.all
      category.each do |k| 
      	@test = Naver_cralwer.new
      	@agent = Mechanize.new
      	@agent = @test.keyword_rslt(category.keyword)
      	@test.shift_to_blog(@agent, category.keyword)
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
    
    def hospital
      if current_user.baby_age.eql? "3m"
        search = "2m"
      elsif current_user.baby_age.eql? "5m" 
        search = "4m"
      elsif current_user.baby_age.eql? ("7m" || "8m" || "9m" || "10m" || "11m")
        search = "6m"
      elsif current_user.baby_age.eql? ("13m" || "14m")
        search = "12m"
      elsif current_user.baby_age.eql? ("16m" || "17m")
        search = "15m"  
      elsif current_user.baby_age.eql? ("20m" || "21m" || "22m" || "23m")
        search = "19m"  
      elsif current_user.baby_age.eql? "3"
        search = "2"  
      elsif current_user.baby_age.eql? "5"
        search = "4"  
      elsif current_user.baby_age.eql? ("7" || "8" || "9" || "10")
        search = "6"  
      else 
        search = current_user.baby_age
      end
      
      @arr = Array.new
      @other = Array.new
      Vaccination.where(age: search).each do |v|
        vac = Hash.new
        vac["disease"] = v.disease
        vac["vaccine_value"] = v.vaccine_value
        vac["vaccination_count"] = v.vaccination_count
        vac["order"] = v.order
        
        if v.other.eql? "1"
          @other << vac
        else
          @arr << vac   
        end
        
      end
    end
    
    def detail
      # 카테고리아이디를 이용해서 크롤러 접근 후 
      # 블로그에서 크롤러 아이디를 이용해서 데이터찾기
      
      @cate_param = params[:category_id]
      @crawler_id = Crawler.where(category_id: @category_id).ids
      @blog = Blog.where(crawler_id: @crawler_id)
    end 
    
    def growth
      if current_user.baby_age.eql? ("13m" || "14m")
        search = "12m"
      elsif current_user.baby_age.eql? ("16m" || "17m")
        search = "15m"
      elsif current_user.baby_age.eql? ("19m" || "20m")
        search = "18m"
      elsif current_user.baby_age.eql? ("22m" || "23m")
        search = "21m"
      else
        search = current_user.baby_age
      end
      
      if current_user.baby_sex.eql? "남"
        if search.include? "m" || search.to_i < 7
          DataBoy.where(baby_age: search).each do |b|
            @resultWeight = b.baby_weight
            @resultHeight = b.baby_height
            @resultHeadLength = b.baby_head_length
          end
        else
          DataBoy.where(baby_age: search).each do |b|
            @resultWeight = b.baby_weight
            @resultHeight = b.baby_height
            @resultHeadLength = 0
          end
        end
      elsif current_user.baby_sex.eql? "여"
        if search.include? "m" || search.to_i < 7
          DataGirl.where(baby_age: search).each do |g|
            @resultWeight = g.baby_weight
            @resultHeight = g.baby_height
            @resultHeadLength = g.baby_head_length
          end
        else
          DataGirl.where(baby_age: search).each do |g|
            @resultWeight = g.baby_weight
            @resultHeight = g.baby_height
            @resultHeadLength = 0
          end
        end
      else 
        @resultWeight = 0
        @resultHeight = 0
        @resultHeadLength = 0
      end
    end
end
