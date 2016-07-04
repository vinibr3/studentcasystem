class API::AuthenticateBase < ApplicationController
			
	respond_to :json
	#before_action :http_token_authentication

	protected 
		def http_base_authentication
			authenticate_or_request_with_http_basic do | username , password |
				encrypted_password = Digest::MD5.hexdigest(password) #"c430b1d23b6cd314543e5931a998b0e6"
				username == "adminuser" && encrypted_password == "da859219a0edfdc3c2f0cd2f9f8c39c4"
				# "adminuser:c430b1d23b6cd314543e5931a998b0e6" Base64 => YWRtaW51c2VyOmM0MzBiMWQyM2I2Y2QzMTQ1NDNlNTkzMWE5OThiMGU2
			end
		end

		def http_token_authentication
			authenticate_or_request_with_http_token do |token, options|
				if token != (params[:estudante_oauth_token] || params[:oauth_token])
					head 401
				end
				Estudante.exists?(oauth_token: token)
			end
		end

		def http_base_authentication_with_entidade_data
			entidade = Entidade.instance
			authenticate_or_request_with_http_basic do |username, password|
				username == "doti" && password == entidade.token_certificado
			end
		end

end
