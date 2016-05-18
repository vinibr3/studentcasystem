class ContatoMailer < ApplicationMailer
	def contato_mensagem(contato)
		@contato = contato
		mail(:to => 'vinicius.deoliveira@outlook.com', :subject => contato.assunto)
	end
end
