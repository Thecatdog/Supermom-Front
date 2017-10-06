# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
CSV.foreach(Rails.root.join('db',"db_girl.csv"), {headers: true, encoding: "UTF-8"}) do |row|
  unless row["baby_age"].nil?
      DataGirl.create! row.to_hash
  end
end

CSV.foreach(Rails.root.join('db',"db_boy.csv"), {headers: true, encoding: "UTF-8"}) do |row|
  unless row["baby_age"].nil?
      DataBoy.create! row.to_hash
  end
end

admin_user = User.create(email: 'admin@email.com', password: '123456', name:'관리자', address: '서울', 
                        baby_name: '김아가', baby_sex: '남', baby_age: '16m', baby_height: '82', baby_weight: '11.10', baby_head_length: '46.2')
admin_user.add_role :admin

User.create(email: 'na@email.com', password: '123456', name:'관리자', address: '서울', 
            baby_name: '최아가', baby_sex: '남', baby_age: '3', baby_height: '96.7', baby_weight: '13.28', baby_head_length: '51.1')

User.create(email: 'abc@email.com', password: '123456', name:'관리자', address: '서울', 
            baby_name: '김냥냥', baby_sex: '여', baby_age: '7', baby_height: '123.84', baby_weight: '22.81', baby_head_length: '')

Category.create(keyword: '아기 건강')
Category.create(keyword: '아기 교육')
Category.create(keyword: '아기 도서')
Category.create(keyword: '아기 생활용품')
Category.create(keyword: '아기 장난감')
Category.create(keyword: '아기 음식')
Category.create(keyword: '아기 여행')
Category.create(keyword: '아기 패션')

Category.create(keyword: '유아 건강')
Category.create(keyword: '유아 교육')
Category.create(keyword: '유아 도서')
Category.create(keyword: '유아 생활용품')
Category.create(keyword: '유아 장난감')
Category.create(keyword: '유아 음식')
Category.create(keyword: '유아 여행')
Category.create(keyword: '유아 패션')

Category.create(keyword: '초등학생 건강')
Category.create(keyword: '초등학생 교육')
Category.create(keyword: '초등학생 도서')
Category.create(keyword: '초등학생 생활용품')
Category.create(keyword: '초등학생 장난감')
Category.create(keyword: '초등학생 음식')
Category.create(keyword: '초등학생 여행')
Category.create(keyword: '초등학생 패션')

Category.create(keyword: '청소년 건강')
Category.create(keyword: '청소년 교육')
Category.create(keyword: '청소년 도서')
Category.create(keyword: '청소년 생활용품')
Category.create(keyword: '청소년 장난감')
Category.create(keyword: '청소년 음식')
Category.create(keyword: '청소년 여행')
Category.create(keyword: '청소년 패션')