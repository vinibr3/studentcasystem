class EstudanteNotificacoes < ApplicationMailer
	def status_notificacoes carteirinha
		@carteirinha = carteirinha
		@estudante = carteirinha.estudante
		@entidade = Entidade.instance
		mail(:to => @estudante.email, :subject => "Solicitação de CIE")
	end
end
