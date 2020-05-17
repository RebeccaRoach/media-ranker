class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    render file: "#{Rails.root}/public/404.html" , status: 404
  end
end
