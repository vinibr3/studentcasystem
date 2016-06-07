class EstudantesController < ApplicationController

	before_action :authenticate_estudante!

	def show
		@estudante = current_estudante
		@carteirinha = @estudante.carteirinhas.last
	end	

	def update
		if current_estudante.update(estudante_params)
			flash[:notice] = "Dados salvos com sucesso!"
			redirect_to current_estudante
		else
			flash[:alert] = current_estudante.errors.full_messages.to_s
			redirect_to current_estudante
		end
	end

	def update_password
		@estudante = Estudante.find(current_estudante.id)
    	if @estudante.update(estudante_params)
	      # Sign in the user by passing validation in case their password changed
	      sign_in @estudante, :bypass => true
	      flash[:notice] = "Dados salvos com sucesso!"
	      redirect_to current_estudante
    	else
     	  flash[:alert] = "Ocorreu um erro."
		  redirect_to current_estudante
    	end
	end

	private
		def estudante_params
			params.require(:estudante).permit(:nome, :cpf, :rg, :data_nascimento, :sexo, :telefone,
											  :logradouro, :complemento, :setor, :cep, :cidade, :uf,
											  :instituicao_ensino_id, :curso_id, :matricula, :foto, 
											  :comprovante_matricula, :xerox_rg, :email, :password, 
											  :celular, :numero, :expedidor_rg, :uf_expedidor_rg)
		end
end