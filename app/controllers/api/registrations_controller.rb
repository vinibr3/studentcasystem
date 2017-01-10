class Api::RegistrationsController < Api::AuthenticateBase
	before_action :http_base_authentication

	def create
			email = registration_params[:email]
			if Estudante.exists?(email: email)
				estudante = Estudante.find_by_email(email: email)
				if estudante.confirmed?
					render_erro "Email já utilizado.", 200
				else
					estudante.send_confirmation_instructions
					render_erro "Antes de continuar confirme seu email. Instruções enviadas para #{estudante.email}.", 200
				end
			else
				@estudante = Estudante.new(registration_params)
				if @estudante.save!
					render_sucess "Um email de confirmação foi enviado para #{email}.", 200
				else 
					render_erro @estudante.errors, 400
				end
			end
	end

	private 
		def registration_params
			params.require(:registration).permit(:email, :password, :password_confirmation)
		end
end