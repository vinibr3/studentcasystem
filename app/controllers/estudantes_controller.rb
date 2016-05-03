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
			flash[:alert] = "Ocorreu um erro: ".concat(current_estudante.errors.full_messages.to_s)
			redirect_to current_estudante
		end
	end

	private
		def estudante_params
			params.require(:estudante).permit(:nome, :cpf, :rg, :data_nascimento, :sexo, :telefone,
											  :logradouro, :complemento, :setor, :cep, :cidade, :uf
											  :instituicao_ensino, :curso_serie, :matricula, :foto, 
											  :comprovante_matricula, :xerox_rg, :email, :password, 
											  :celular, :numero, :expedidor_rg, :uf_expedidor_rg,
											  :cidade_inst_ensino, :uf_inst_ensino
		end

end