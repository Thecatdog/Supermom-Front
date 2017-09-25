class UserController < ApplicationController
    before_filter :authenticate_user!, :except =>[:index]
    layout 'login_layout'
end
