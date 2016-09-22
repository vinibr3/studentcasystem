class Api::EstudantesController < API::AuthenticateBase
	before_action :http_token_authentication

	def update
		# begin 
			@estudante = Estudante.find(params[:estudante][:id])
			if @estudante
				if @estudante.update_attributes(estudante_params)
					head 204
				else
					render_erro @estudante.errors, :status => 422
				end
			else
				render_erro "Estudante não encontrado. Email: #{params[:estudante][:email]}", :status => 404
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