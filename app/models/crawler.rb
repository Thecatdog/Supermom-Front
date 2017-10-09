class Crawler < ActiveRecord::Base
    has_many :blogs
    validates_uniqueness_of :blog_link
end
