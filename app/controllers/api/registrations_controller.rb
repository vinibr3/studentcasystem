class Api::RegistrationsController < Api::AuthenticateBase
	before_action :http_base_authentication

	def create
		begin
			@estudante = Estudante.new(estudante_params)
			if @estudante.save
				respond_with @estudante, :status => 201
			else 
				render_erro @estudante.errors, 400
			end
		rescue Exception => ex
			render_erro ex.message, 500
		end
	end
end