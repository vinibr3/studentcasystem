class CidadesController < ApplicationController
	def show
		@estado = Estado.find params[:estado_id]
		@cidades = @estado.cidades if @estado
		respond_to do |format|
			format.js
		end
	end	
end
