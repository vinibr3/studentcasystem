class Api::SessionsController < Api::AuthenticateBase

	before_action :http_login_password_authentication,  only: [:create]
	before_action :http_base_authentication, only: [:facebook]

	def create
		@estudante = Estudante.find_by(email: params[:email])
		if @estudante
			if @estudante.confirmed?
				respond_with @estudante, status => 200
			else
				@estudante.send_confirmation_instructions
				render_erro "Antes de continuar confirme seu email. Instruções enviadas para #{estudante.email}.", 200
			end
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