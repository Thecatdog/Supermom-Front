class HomeController < ApplicationController
  before_filter :authenticate_user!, :except =>[:index]
  
  def index
  end
  
  def mongodbtest 
    # @car = Car.all
  end
  before_filter :authenticate_user!, :except =>[:index]
end
