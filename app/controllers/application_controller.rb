class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render file: "#{Rails.root}/public/404.html" , status: 404
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end
  # helper view method that makes current_user method available in view
  helper_method :current_user
end
