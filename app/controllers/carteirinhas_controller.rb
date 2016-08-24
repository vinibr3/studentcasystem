class CarteirinhasController < ApplicationController

	before_action :authenticate_estudante!, except: [:consulta, :show, :carteirinha_image]

	def show
		
	end

	def carteirinha_image
		@carteirinha = Carteirinha.find(params[:id])
		send_data @carteirinha.to_blob, :type=>"image/jpg", :disposition=>"inline"
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
			if params[:termos] == false
				flash[:alert] = "Termos devem ser aceitos."
				redirect_to estudante_path(current_estudante)
			else
				redirect_to checkout_path(valor_carteirinha: params[:valor_carteirinha], frete_carteirinha: params[:frete_carteirinha])
			end	
		end
	end

	def consulta		
		@carteirinha = Carteirinha.find_by_codigo_uso(params[:carteirinha][:codigo_uso])
		if verify_recaptcha(model: @carteirinha)
			respond_to do |format|
				format.html{redirect_to consulta_url}
				format.js
			end
		else
		  redirect_to consulta_url
		end			
	end

	private
		def carteirinha_params
			params.require(:carteirinha).permit(:valor_carteirinha, :termos, :frete_carteirinha)
		end
end
