class CertificadosController < ApplicationController
	def show
		@estudante = Estudante.find_by_chave_acesso(params[:chave_acesso])
		if @estudante
			@carteirinhas = @estudante.carteirinhas
			if @carteirinhas
				carteirinha = @carteirinhas.last
				if carteirinha.valid?
					send_data carteirinha.certificado, type: 'application/pkix-cert', filename: "#{carteirinha.numero_serie}.cer"
				else
					head 404
				end
			else
				head 404
			end 
		else
			head 404
		end
	end
end
