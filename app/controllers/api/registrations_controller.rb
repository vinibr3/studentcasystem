class Api::RegistrationsController < Api::AuthenticateBase
	before_action :http_base_authentication

	def create
		begin
			email = registration_params[:email]
			if Estudante.exists?(email: email)
				render_erro "Email já utilizado.", 200
			end

			@estudante = Estudante.new(registration_params)
			if @estudante.save!
				render_sucess "Um email de confirmação foi enviado para #{email}.", 200
			else 
				render_erro @estudante.errors, 400
			end
		rescue Exception => ex
			render_erro ex.message, 500
		end
	end

	private 
		def registration_params
			params.require(:registration).permit(:email, :password, :password_confirmation)
		end
end