class ContatoMailer < ApplicationMailer
	def contato_mensagem(contato)
		@contato = contato
		mail(:to => ENV["STUDENTCASYSTEM_EMAIL_USER"], :subject => contato.assunto)
	end
end
