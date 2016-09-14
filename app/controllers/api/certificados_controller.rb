class Api::CertificadosController < API::AuthenticateBase
	before_action :http_base_authentication_with_entidade_data

	def create
		params[:certificados].each do |certificado|
				@carteirinha = Carteirinha.find(certificado[:carteirinha_id])
				@carteirinha.certificado = certificado[:certificado]
				@carteirinha.save!
		end
		render json: {message: "#{params[:certificados].size} Certificados de Atributo criados com sucesso.", type: 'success'}, :status => 200
	end

	private
		def certificado_params
			params.require(:certificados).permit(:carteirinha_id,:certificado)
		end
end