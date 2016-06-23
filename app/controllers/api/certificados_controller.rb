class Api::CertificadosController < API::AuthenticateBase
	before_action :http_base_authentication_with_entidade_data, only: [:create]

	def create
		begin
			params[:certificados].each do |certificado|
				@carteirinha = Carteirinha.find(certificado[:id])
				@carteirinha.certificado = certificado[:base64_encoded]
				@carteirinha.save!
			end
			render json: {message: "Os Certificados de Atributo foram criados com sucesso.", type: 'success'}, :status => 200
		rescue Exception => ex
			render json: {errors: ex.message, type: 'erro'}, :status => 501
		end
	end

	private
		def certificado_params
			params.require(:certificados).permit(:id,:base64_encoded)
		end
end