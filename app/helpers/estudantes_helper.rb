module EstudantesHelper
	def helper_title atributos
		title=nil
		if atributos.empty? 
			title = "Seus dados estão preenchidos. Aceite os termos e efetue o pagamento para solicitar seu Documento."
		else
			title = "Preencha o formulário para solicitar seu Documento"
		end
		content_tag(:p, title, class: 'lead text-center')
	end
end