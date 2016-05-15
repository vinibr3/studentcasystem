class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery 
  skip_before_action :verify_authenticity_token if :json_request?
  
  respond_to :html

  def access_denied(exception)
    redirect_to  admin_carteirinhas_path, :alert => exception.message
  end

   protected 
  	def json_request?
  		request.format.json?
  	end	
end
