class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:address,:baby_name,:baby_sex,:baby_age,:baby_height,:baby_weight,:baby_head_length,:categorys_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name,:address,:baby_name,:baby_sex,:baby_age,:baby_height,:baby_weight,:baby_head_length,:categorys_id])
  end
  
  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
  
end
