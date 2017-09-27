class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  after_create :assign_default_role
  
  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Authority::UserAbilities
  has_many :meetings
  after_create :assign_default_role, if: Proc.new { User.count >1 }
  private
    def assign_default_role
    	add_role :user
    end
  
end
