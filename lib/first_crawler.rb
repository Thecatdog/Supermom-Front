require '~/Supermom-Front/lib/crawling.rb'
require '~/Supermom-Front/lib/naver_crawler.rb'
@n_crawler = Naver_cralwer.new
@a_proxy = @n_crawler.create_proxy
baby = Array.new
child = Array.new
elementary = Array.new
adolescent = Array.new

Category.all.each do |c|
	if c.keyword.include? "아기"
		baby<<c.id
	elsif c.keyword.include? "유아"
		child<<c.id
	elsif c.keyword.include? "초등학생"
		elementary<<c.id
	else
		adolescent<<c.id
	end
end

@f_crawler_m = Crawling.new
baby.each do |b|
	begin
		@f_crawler_m.crawler(Category.find(b),@a_proxy)
	rescue
		puts "error in baby crawler"
		retry
	end
end

child.each do |c|
	begin
		@f_crawler_m.crawler(Category.find(c),@a_proxy)
	rescue
		puts "error in child crawler"
		retry
	end
end
elementary.each do |e|
	begin
		@f_crawler_m.crawler(Category.find(e),@a_proxy)
	rescue
		puts "error in elementary crawler"
		retry
	end
end
adolescent.each do |a|
	begin
		@f_crawler_m.crawler(Category.find(a),@a_proxy)
	rescue
		puts "error in adolescent crawler"
		retry
	end
end
