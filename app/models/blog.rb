class Blog < ActiveRecord::Base
    belongs_to :crawlers
    validates_uniqueness_of :blog_link
end
