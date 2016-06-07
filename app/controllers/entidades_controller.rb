class EntidadesController < ApplicationController

	before_action :authenticate_estudante!

	def escolaridades 
		entidade = Entidade.instance
		escolaridades = entidade.escolaridades_from_json_file params[:instituicao]
		respond_to  do |format|
			format.js
		end
	end

	def cursos
		entidade = Entidade.instance
		@cursos = entidade.cursos_from_json_file params[:instituicao], params[:escolaridade]
		respond_to do |format|
			format.js
		end
	end
	
end
