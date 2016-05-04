class Api::CarteirinhasController < API::AuthenticateBase

	def show
		begin
			@estudante = Estudante.find_by_oauth_token(params[:estudante_oauth_token])
			if @estudante
				if @estudante.carteirinha.empty?
					message = "Nenhuma Carteira de Identificação Estudantil encontrada."
		    	render json: {errors: message, type: 'erro'}, :status => 404 
		    else
		    	respond_with @estudante.carteirinha.last, :status => 200
		    end
		  else
		  	message = "Estudante não encontrado, oauth_token: #{params[:estudante_oauth_token]}"
		  	render json: {errors: message, type: 'erro'}, :status => 404
		  end
		rescue Exception => ex
			render json: {errors: ex.message, type: 'erro'}, :status => 500
		end
	end

	def create
		begin 
			@estudante = Estudante.find_by_oauth_token(params[:estudante_oauth_token])
			if @estudante
				if @estudante.atributos_em_branco.empty?
					@carteirinhas = @estudante.carteirinha
					if @carteirinhas && @carteirinhas.last && @carteirinhas.last.em_solicitacao?
						@last_carteirinha = @carteirinhas.last
						message = "Carteira de Identificação Estudantil já solicitada"
						render json: {errors: message, status_versao_digital: @last_carteirinha.status_versao_digital,
							                             status_versao_impressa: @last_carteirinha.status_versao_impressa,
							                             type: 'erro'}, :status => 422
					else
						nova_carteirinha = @estudante.carteirinha.new(carteirinha_params) do |c|
							c.nome = @estudante.nome
							c.instituicao_ensino = @estudante.instituicao_ensino
							c.curso_serie = @estudante.curso_serie
							c.matricula = @estudante.matricula
							c.rg_certidao = @estudante.rg_certidao
							c.data_nascimento = @estudante.data_nascimento
							c.cpf = @estudante.cpf
							c.foto = @estudante.foto
						end	
						if nova_carteirinha.save
							# Metodo que envia boleto aqui
							respond_with nova_carteirinha, :status => 201
						else
							render json: {errors: nova_carteirinha.errors, type: 'erro'}, :status => 422
						end
					end
				else
					atributos_em_branco = @estudante.atributos_em_branco.to_s
					message = "Dados não preenchidos: #{atributos_em_branco}"
					render json: {errors: message, type: 'erro'}, :status => 422
				end
			else
				message = "Estudante não encontrado, oauth_token: #{params[:estudante_oauth_token]}"
				render json: {errors: message, type: 'erro'}, :status => 404
			end
		rescue => ex
			render json: {errors: ex.message, type: 'erro'}, :status => 500
		end
	end

	private 
		def carteirinha_params
			params.require(:carteirinha).permit(:versao_digital, :versao_impressa, :valor)
		end
end