class CursosController < ApplicationController
	def show 
		@escolaridade = Escolaridade.find(params[:escolaridade_id])
		@cursos = @escolaridade.cursos if @escolaridade
		respond_to do |format|
			format.js
		end
	end
end
