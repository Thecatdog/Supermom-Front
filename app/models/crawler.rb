class Crawler < ActiveRecord::Base
    belongs_to :link
    has_many :blogs
end
