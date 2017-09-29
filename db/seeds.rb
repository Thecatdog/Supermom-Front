# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin_user = User.create(email: 'admin@email.com', password: '123456', name:'관리자', address: '서울', 
                        baby_name: '김아가', baby_sex: '여', baby_age: '1', baby_height: '50cm', baby_weight: '10kg', baby_head_length: '20cm')
admin_user.add_role :admin