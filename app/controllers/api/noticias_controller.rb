class Api::NoticiasController < API::AuthenticateBase

	skip_before_action :http_token_authentication

	def index
		begin
			@noticias = Noticia.all.where("id > #{params[:id]}")
			if @noticias.empty?
				 head 304
			else
				respond_to @noticias, :status => 200
			end
		rescue => ex
			render json:{error: ex.message, type: 'erro'}, :status => 500
		end
	end

	private
		def noticias_params
			params.require(:noticias).permit(:id)
		end
end