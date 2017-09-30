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
                        baby_name: '김아가', baby_sex: '여', baby_age: '1', baby_height: '50cm', baby_weight: '10kg', baby_head_length: '20cm', categorys_id: '1')
admin_user.add_role :admin

User.create(email: 'nayoung8110@likelion.org', password: '123456', name: '김나영', address: '서울', 
                        baby_name: '김냥냥', baby_sex: '여', baby_age: '2', baby_height: '50cm', baby_weight: '3kg', baby_head_length: '15cm', categorys_id: '1')