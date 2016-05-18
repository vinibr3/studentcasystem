class ContatosController < ApplicationController
	def create
		@contato = Contato.new(contato_params)
		if @contato.valid?
			ContatoMailer.contato_mensagem(@contato).deliver
			flash.notice = 'Recebemos seu contato, retornaremos em breve.'
			redirect_to contato_path
		else
			flash.alert = 'Ocorreu um erro: '.concat(@contato.errors.full_messages.to_s)
			redirect_to contato_path
		end
	end

	private 
		def contato_params
			params.require(:contato).permit(:nome,:email,:assunto,
				                            :mensagem,:telefone)
		end
end
