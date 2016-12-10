class EstudantesController < ApplicationController

	before_action :authenticate_estudante!

	def show
		@estudante = current_estudante
		@carteirinhas = current_estudante.carteirinhas.each{|carteirinha| carteirinha if carteirinha}
		@entidade = Entidade.instance
	end	

	def update
		cidades = Estado.find_by_sigla(estudante_params[:uf]).cidades
		estudante_params[:cidade_id] = cidades.find_by_nome(estudante_params[:cidade_id]).id
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
											  :logradouro, :complemento, :setor, :cep, :cidade_id, :uf,
											  :instituicao_ensino_id, :curso_id, :matricula, :foto, 
											  :comprovante_matricula, :xerox_rg, :email, :password, 
											  :celular, :numero, :expedidor_rg, :uf_expedidor_rg, 
											  :callback, :xerox_cpf)
		end
end