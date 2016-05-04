class CarteirinhasController < ApplicationController

	before_action :authenticate_estudante!, except: [:autenticacao, :show]

	def show
		
	end

	def new
		
	end

	def create 
		
		@carteirinha = current_estudante.carteirinhas.new(carteirinha_params) do |c|
			c.nome = current_estudante.nome
			c.rg = current_estudante.rg
			c.cpf = current_estudante.cpf
			c.data_nascimento = current_estudante.data_nascimento
			c.matricula = current_estudante.matricula
			c.expedidor_rg = current_estudante.expedidor_rg
			c.uf_expedidor_rg = current_estudante.uf_expedidor_rg
			c.instituicao_ensino = current_estudante.instituicao_ensino
			c.cidade_inst_ensino = current_estudante.cidade_inst_ensino
			c.escolaridade = current_estudante.escolaridade
			c.uf_inst_ensino = current_estudante.uf_inst_ensino
			c.curso_serie = current_estudante.curso_serie
			c.foto = current_estudante.foto
			c.valor = Carteirinha.VALOR+Carteirinha.FRETE
			c.layout_carteirinha_id = LayoutCarteirinha.last
		end 

		if @carteirinha.save!
			flash[:notice] = "Solicitação enviada com sucesso!"
			redirect_to estudante_path(current_estudante)
		else
			flash[:alert] = "Ocorreu um erro: ".concat(@carteirinha.errors.messages.to_s)
			redirect_to estudante_path(current_estudante)
		end
	end

	def autenticacao
		if request.post?
			@carteirinha = Carteirinha.find_by_numero_serie(carteirinha_params[:numero_serie])
			if @carteirinha && @carteirinha.valid?
				respond_to do |format|
					format.html
					format.json { render json: @carteirinha}
				end
			else
				respond_to do |format|
					@carteirinha = nil
					format.html { flash[:alert] = "Nº de Série inválido ou documento vencido."}
					format.json {}
				end
			end
		end		
	end

	private
		def carteirinha_params
			params.require(:carteirinha).permit(:numero_serie, :versao_impressa, :valor, :termos, :validade)
		end
end
