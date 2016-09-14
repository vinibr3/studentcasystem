class Api::NoticiasController < API::AuthenticateBase
	def index
		begin
			@noticias = Noticia.where("id > #{params[:id]}")
			if @noticias.empty?
				 head 304
			else
				respond_with @noticias, :status => 200
			end
		rescue => ex
			render_erro ex.message, :status => 500
		end
	end

	private
		def noticias_params
			params.require(:noticias).permit(:id)
		end
end