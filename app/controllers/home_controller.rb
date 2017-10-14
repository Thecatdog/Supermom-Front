class HomeController < ApplicationController
  before_filter :authenticate_user!, :except =>[:index]
  # require 'twitter-korean-text-ruby'
  # @module = TwitterKorean::Processor.new
  require 'rufus-scheduler'
  helper_method :keyword_extraction
  helper_method :keyword_ranking
    def index1
      require '~/Supermom-Front/lib/naver_crawler.rb'
      if params[:choose_categories].nil?
        @categories = ""
      else
        @categories = params[:choose_categories]
      end
      @categories_array = ["건강","교육","도서","생활용품","장난감","음식","여행","패션"]
      @baby_age = User.find(current_user.id).baby_age
      scheduler = Rufus::Scheduler.new
      
      
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
        require '~/Supermom-Front/lib/naver_crawler.rb'
      	for j in i..i+7
          cate = Category.find(j)
          @test = Naver_cralwer.new
          @agent = Mechanize.new
          @agent = @test.keyword_rslt(cate.keyword)
        	@test.shift_to_blog(@agent, cate.keyword)
        	Crawler.where(category_id: Category.where(keyword: cate.keyword).take.id).each do |c|
        	 Blog.where(blog_link: c.blog_link).each do |b|
        	   keyword_extraction(b.blog_title, cate.keyword.gsub(" ", ""))
        	 end
        	end
        end
      end
      
      if User.find(current_user.id).sign_in_count==0
        for j in i..i+7
        cate = Category.find(j)
        @test = Naver_cralwer.new
        @agent = Mechanize.new
        @agent = @test.keyword_rslt(cate.keyword)
      	@test.shift_to_blog(@agent, cate.keyword)
      	Crawler.where(category_id: Category.where(keyword: cate.keyword).take.id).each do |c|
      	 Blog.where(blog_link: c.blog_link).each do |b|
      	   keyword_extraction(b.blog_title, cate.keyword.gsub(" ", ""))
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

    def keyword_extraction(blog_title,keyword)
      require 'twitter-korean-text-ruby'
      @module = TwitterKorean::Processor.new
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
