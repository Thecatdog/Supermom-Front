class HomeController < ApplicationController
  before_filter :authenticate_user!, :except =>[:index]
  require 'twitter-korean-text-ruby'
  @module = TwitterKorean::Processor.new
    def index1
      require '~/workspace/lib/naver_crawler.rb'
      if params[:choose_categories].nil?
        @categories = ""
      else
        @categories = params[:choose_categories]
      end
      @categories_array = ["건강","교육","도서","생활용품","장난감","음식","여행","패션"]

    end
    
    def keyword_extraction(blog_title,keyword)
      blog = Blog.where(blog_title: blog_title).take
      blog_tags = blog.tag
      blog_tags_ary = blog_tags.split(" ")
      @b_title = blog_title
      @divide_b_title = @module.extract_phrases(@b_title)
      base_dic=base_word
      @noun_content = []
      @divide_b_title.each do |s|
        if s.length>3
          @metadata = s.metadata
          if @metadata.pos.to_s.include? "noun"
              if base_dic.include? s
              else
                  @noun_content << s
              end
          elsif @metadata.pos.to_s.include? "alpha"
            @noun_content << s
          else
          end
        end
      end
      
      @complete = []
      @noun_content.each do |n|
        n = n.gsub(" ","")
        blog_tags_ary.each do |t|
          if n.include? t
            @complete << t
          end
        end
      end
      @complete = @complete.uniq
      
      crawler = Crawler.where(blog_link: blog.blog_link).take
      crawler.regulated_tag = ""
      @complete.each do |c|
        if c==keyword
          @complete.delete(c)
        end
      end
      
      @complete.each do |c|
        crawler.regulated_tag = crawler.regulated_tag + c + " "
      end
      
      crawler.save


    end
    
    def base_word
      aFile = File.new('public/base_word.txt','r')
      fSize = aFile.stat.size
      if aFile
        content = aFile.sysread(fSize)
      else
          puts 'Unable open file'
      end
      base = content.to_s.force_encoding("UTF-8")
      base_dic = @module.stem(base)
      base_dic.delete("\",\"")
      base_dic.delete("\"]")
      base_dic.delete("[\"")
      base_dic.delete(";\",\"")
      josa = ["이","가","께서","의","을","를","에","에게","께","한테","에서","와","과","로","으로","로서","으로서","로써","으로써","보다","랑","이랑","만큼","하고","더러","보고","이다","고","라고","이라고","며","이고","이며","이면","면","아","야","여","이여","이시여","요","은","는","도","만","조차","밖에","뿐","나","이나","깨나","일랑","부터","까지","라고","이라고","라도","이라도","마는","들", "그려", "그래", "손", "이야", "야", "다가", "커녕", "치고", "마다", "서껀", "야말로", "이야말로", "엔들", "이란", "란", "곧", "대로", "따라", "토록", "든지", "이든지", "이라야", "인즉"]
      base_dic = base_dic+josa
      return base_dic
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
end
