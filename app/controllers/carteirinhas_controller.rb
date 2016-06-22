class CarteirinhasController < ApplicationController

	before_action :authenticate_estudante!, except: [:autenticacao, :show]

	def show
		
	end

	def new
		
	end

	def create 
		atributos = current_estudante.atributos_nao_preenchidos
		if atributos.count > 0
			campos = ""
			atributos.collect{|f| campos.concat(f.to_s.humanize.concat(", "))}
			flash[:alert] = "Campo(s) #{campos} não preenchido(s)."
			redirect_to estudante_path(current_estudante)
		else
			@carteirinha = current_estudante.carteirinhas.new(carteirinha_params) do |c|
			c.nome = current_estudante.nome
			c.rg = current_estudante.rg
			c.cpf = current_estudante.cpf
			c.data_nascimento = current_estudante.data_nascimento
			c.matricula = current_estudante.matricula
			c.expedidor_rg = current_estudante.expedidor_rg
			c.uf_expedidor_rg = current_estudante.uf_expedidor_rg
			@instituicao = InstituicaoEnsino.find(current_estudante.instituicao_ensino_id)
			c.instituicao_ensino = @instituicao.nome
			c.cidade_inst_ensino = @instituicao.cidade.nome
			c.escolaridade = current_estudante.escolaridade.nome
			c.uf_inst_ensino = @instituicao.estado.sigla
			c.curso_serie = current_estudante.curso.nome
			c.foto = current_estudante.foto
			c.layout_carteirinha = LayoutCarteirinha.last
			status = Carteirinha.class_variable_get(:@@STATUS_VERSAO_IMPRESSA)
			c.status_versao_impressa = status[0]
			end 

			if @carteirinha.save!
				redirect_to checkout_path(id: @carteirinha.id)
			else
				flash[:alert] = @carteirinha.errors.messages.to_s
				redirect_to estudante_path(current_estudante)
			end
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
