
class Naver_cralwer
	
	require 'rubygems'
	require 'mechanize'
	require 'rest-client'
	require 'resolv-replace.rb'
	
	def create_proxy
		manager = ProxyFetcher::Manager.new
		manager.cleanup!
		return manager.proxies
	end	

	def check_vaild_proxy(url, proxy)
		begin
			agent = Mechanize.new
			agent.set_proxy(proxy.addr,proxy.port)
			agent.get(url)
		rescue
			return false
		end
		return true	
	end
	# -----------------------------------------
	# blog 본문에 들어가 tag를 가져오는 메소드 시작
	
	def get_tag(blog_link_uri,proxy)
		agent = Mechanize.new
		agent.ssl_version = :TLSv1
		@tags = []
		proxy.each do |p|
			if check_vaild_proxy(blog_link_uri,p)
				agent.set_proxy(p.addr,p.port)
				break;
			else
			end
		end
		# 새로운 에러
		# blog.me가 agent를 통해서 들어가게 되면 blog.com으로 바뀌는 현상
		# agent를 if문 밖으로 빼서 blog_link_uri 를 갱신
		# html 변수는 if문에서 계속 사용해야하므로 밖에서 영향력 없이 사용가능하도록 세팅 

		html = agent.get(blog_link_uri)
		blog_link_uri = html.uri.to_s

		if blog_link_uri.include? "blog.me"
			second_uri = html.search('frame').attr('src')
			page = agent.get(second_uri)
			blog_link_uri = page.uri.to_s
		end
		blog_link_uri = blog_link_uri.gsub("http://", "http://m.")
		
	
		page  = agent.get(blog_link_uri)
		page.search('div.post_tag').each do |t|
	  		@tags= t.text.gsub('#', '')
	  	end
		# 원래 페이지로 돌아가기
		return @tags
	end
	# blog 본문에 들어가 tag를 가져오는 메소드 끝
	# -----------------------------------------
	
	
	# -----------------------------------------
	# 네이버 본문에서 keyword 검색 결과 가져오기
	def keyword_rslt(key,proxy)
		# main가져오기
		agent = Mechanize.new
		agent.ssl_version = :TLSv1
		proxy.each do |p|
			if check_vaild_proxy("http://naver.com",p)
				agent.set_proxy(p.addr,p.port)
				break;
			else
			end
		end
		page = agent.get "http://naver.com"
		search_form = page.form_with :name => "sform"
		search_form.field_with(:name=>"query").value = key
		search_results = agent.submit search_form
		main_uri = search_results.uri

		return agent
	end
	# -----------------------------------------
	

	# -----------------------------------------
	# 메인에서 블로그 이동
	def shift_to_blog(agent, key,proxy)

		# 메인에서 블로그 이동
		page = agent.page.link_with(:text => '블로그').click
		
		# 페이지를 5번째 페이지까지
		for i in 1..5
			@blog_title = []
			@blog_s_content = []
			@blog_link = []
			@blog_tag = []
			
			
			html = agent.get(page.uri).body
			html_doc = Nokogiri::HTML(html)
			blog_section = html_doc.css('ul#elThumbnailResultArea.type01')
			blog_head = blog_section.css('dt').css('a')
			blog_mini_content = blog_section.css('dd.sh_blog_passage')
			blog_date = blog_section.css('dd.txt_inline')
		
			# title 10개를 차례대로 뽑기
			blog_head.each_with_index do |v, i|
				# puts v.attr('title')
				@blog_title << v.attr('title')
				# @blog.blog_title = v.attr('title')
			end
		
			# 소주제 10개를 차례대로 뽑기
			blog_mini_content.each_with_index do |v, i|
				# puts v.text
				@blog_s_content << v.text
				# @blog.blog_s_content = v.text
			end
		
			# 블로그 본문으로 들어가기 
			page = agent.page.link_with(:text => '다음페이지').click
		
			
			for j in 0..8
				blog_link_uri = blog_head[j].attr('href')
				# blog link_uri
				
				
				@blog_link << blog_link_uri
				# @blog.blog_link = blog_link_uri
				# @crawler.blog_link = blog_link_uri

				ary = Array.new	
				# 주소가 blog와 관련된 것만 태그를 뽑아옴 

				if blog_link_uri.include? "blog.me"
					ary=get_tag(blog_link_uri,proxy)
					sleep 2
				elsif blog_link_uri.include? "blog.naver.com"
					ary=get_tag(blog_link_uri,proxy)
					sleep 2
				else
				end	
				@blog_tag << ary
			end
			
			for k in 0..8
				@crawler = Crawler.new
				@crawler.save
				
		    	@blog = Blog.new
				@blog.crawler_id = @crawler.id
				@blog.blog_title=@blog_title[k]
				@blog.blog_s_content=@blog_s_content[k]
				@blog.blog_link=@blog_link[k]
				@crawler.blog_link=@blog_link[k]
				@blog.tag=@blog_tag[k]
				@blog.tag = @blog.tag.squish
				@blog.save
				@crawler.category_id = Category.where(keyword: key).take.id
				@crawler.save
			end
		end
	end
	# -----------------------------------------

end

