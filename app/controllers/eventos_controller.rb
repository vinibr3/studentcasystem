class EventosController < ApplicationController

	def show
		@evento = Evento.find(params[:id])
	end

end
