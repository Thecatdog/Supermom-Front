class Crawling
    require '~/Supermom-Front/lib/naver_crawler.rb'

    def crawler
        Category.all.map.each do |c|
            cate = c
            @n_crawler = Naver_cralwer.new
            @agent = Mechanize.new
            @agent = @n_crawler.keyword_rslt(cate.keyword)
            @n_crawler.shift_to_blog(@agent, cate.keyword)
            Crawler.where(category_id: Category.where(keyword: cate.keyword).take.id).each do |c|
             Blog.where(blog_link: c.blog_link).each do |b|
               keyword_extraction(b.blog_title, cate.keyword.gsub(" ", ""))
             end
            end
        end
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
    
end
