class Api::EstudantesController < API::AuthenticateBase

	before_action :http_base_authentication, only: [:create]
	before_action :http_token_authentication

	def login
		begin 
			@estudante = Estudante.find_by(email: params[:email])
			if @estudante
				if @estudante.valid_password?(params[:password])
					respond_with @estudante, :status => 200
				else
					render json: {errors: @estudante.errors, type: 'erro'}, :status => 400
				end
			else
				message = "Estudante não encontrado. Email : #{params[:email]}"
				render json: {errors: message, type: "erro"}, :status => 404
			end
		rescue Exception => ex
			render json: {errors: ex.message, type: "erro"}
		end
	end

	def facebook
    begin
	    @estudante = Estudante.first_or_create_from_koala(params[:access_token])
			if @estudante.persisted? 
				respond_with @estudante, :status => 200
			else
				render json: {errors: @estudante.errors, type: 'erro'}, :status => 422
			end
		rescue Koala::Facebook::APIError => error
			render json: {errors: error.fb_error_message, type: 'erro'}, :status => error.http_status
		rescue Koala::Facebook::AppSecretNotDefinedError => error
			render json: {errors: error, type: 'erro'}, :status => 500
		rescue Koala::Facebook::OAuthSignatureError => error
			render json: {errors: error, type: 'erro'}, :status => 500
		rescue Exception => ex
			render json: {errors: ex.message, type: 'erro'}, :status => 500
		end
	end

	def create
		begin
			@estudante = Estudante.new(estudante_params)
			if @estudante.save
				respond_with @estudante, :status => 201
			else 
				render json:{errors: @estudante.errors, type: 'erro'}, :status => 400
			end
		rescue Exception => ex
			render json: {errors: ex.message, type: 'erro'}, :status => 500
		end
	end

	def update
		# begin 
			@estudante = Estudante.find(params[:estudante][:id])
			if @estudante
				if @estudante.update_attributes(estudante_params)
					head 204
				else
					render json:{errors: @estudante.errors, type: 'erro'}, :status => 422
				end
			else
				message = "Estudante não encontrado. Email: #{params[:estudante][:email]}"
				render json: {errors: message, type: 'erro'}, :status => 404
			end
		# rescue Exception => ex
		# 	render json: {errors: ex.message}, :status => 500
		# end
	end

	private
		def estudante_params
			params.require(:estudante).permit(:nome, :cpf, :rg, :data_nascimento, :sexo, :telefone,
											  :logradouro, :complemento, :setor, :cep, :cidade,
											  :instituicao_ensino, :curso_serie, :matricula, :foto, 
											  :comprovante_matricula, :xerox_rg, :email, :password, 
											  :celular, :numero, :id, :provider, :oauth_token, :uf,
											  :uf_inst_ensino, :expedidor_rg, :uf_expedidor_rg, 
											  :escolaridade)
		end
end