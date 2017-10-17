class HomeController < ApplicationController
  before_filter :authenticate_user!, :except =>[:index]
  # require 'twitter-korean-text-ruby'
  # @module = TwitterKorean::Processor.new
  require 'rufus-scheduler'
  require '~/Supermom-Front/lib/naver_crawler.rb'
  require '~/Supermom-Front/lib/crawling.rb'
  helper_method :keyword_extraction
  helper_method :keyword_ranking

    def index1
      if params[:choose_categories].nil?
        @categories = ""
      else
        @categories = params[:choose_categories]
      end
      @categories_array = ["건강","교육","도서","생활용품","장난감","음식","여행","패션"]
      @baby_age = User.find(current_user.id).baby_age
      scheduler = Rufus::Scheduler.new
      current_u = User.find(current_user.id)
      
      if @baby_age.include? "m"
        i=1
      elsif @baby_age.include? "개월"
        i=1
      else
        @baby_age = @baby_age.to_i
        case
        when @baby_age<=3 then
          i=1
        when @baby_age >3 && @baby_age<=7 then
          i=9
        when @baby_age >=8 && @baby_age<=13 then
          i=17
        else
          i=25
        end
      end
      
      scheduler.cron '5 0 * * *' do
      	for j in i..i+7
          cate = Category.find(j)
          @n_crawler = Naver_cralwer.new
          @f_crawler_m = Crawling.new
          @agent = Mechanize.new
          @agent = @n_crawler.keyword_rslt(cate.keyword)
        	@n_crawler.shift_to_blog(@agent, cate.keyword)
        	Crawler.where(category_id: Category.where(keyword: cate.keyword).take.id).each do |c|
        	 Blog.where(blog_link: c.blog_link).each do |b|
        	   @f_crawler_m.keyword_extraction(b.blog_title, cate.keyword.gsub(" ", ""))
        	 end
        	end
        end
      end
      
    end
    
    def keyword_ranking(cate)
      h = Hash.new
      Crawler.where(category_id: Category.where(keyword: cate).take.id).each do |c|
        if c.regulated_tag.nil?
          c.regulated_tag = ""
        end
        c.regulated_tag.split(" ").each do |rt|
          if h.has_key?(rt)
          else
            h[rt] = 0
          end
        end
      end
      h.keys.each do |key|
        Blog.all.each do |b|
          if b.blog_title.gsub(" ","").include? key
            h[key] = h[key]+1
          end
        end
      end
      sort_h = h.sort_by { |keyword, cnt| cnt }.reverse
      return sort_h
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
      @crawler_id = Crawler.where(category_id: @cate_param).ids
      # @blog = Blog.where(crawler_id: @crawler_id)
    end 
    def keyworddetail
      @keyword_ranking = params[:ranking_num].to_i
      @cate_param = params[:category_id]
    end

end
