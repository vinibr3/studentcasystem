class Api::SessionsController < API::AuthenticateBase

	before_action :http_login_password_authentication,  only: [:create]

	def create
		@estudante = Estudante.find_by(email: params[:email])
		respond_with @estudante, :status => 200
		begin 
			@estudante = Estudante.find_by(email: params[:email])
			respond_with @estudante, :status => 200
			if @estudante
				if @estudante.valid_password?(params[:password])
					respond_with @estudante, :status => 200
				else
					render_erro @estudante.errors, 404
				end
			else
				render_erro "Estudante não encontrado. Email : #{params[:email]}", 404
			end
		rescue Exception => ex
			#render_erro ex.message, 500
		end
	end

	def facebook
    begin
	    @estudante = Estudante.first_or_create_from_koala(params[:access_token])
			if @estudante.persisted? 
				respond_with @estudante, :status => 200
			else
				render_erro @estudante.errors, 422
			end
		rescue Koala::Facebook::APIError => error
			render_erro error.fb_error_message, error.http_status
		rescue Koala::Facebook::AppSecretNotDefinedError => error
			render_erro error.fb_error_message, error.http_status
		rescue Koala::Facebook::OAuthSignatureError => error
			render_erro error.fb_error_message, error.http_status
		rescue Exception => ex
			render_erro error.fb_error_message, error.http_status
		end
	end

end