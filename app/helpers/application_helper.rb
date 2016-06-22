module ApplicationHelper
	def presentation_name nome
		nome=nil
		if nome
			nome = current_estudante.email_less_domain
		else
			nome = current_estudante.first_name
		end
		cumprimento = "Olá, #{nome}"
		content_tag :li  do
			link_to cumprimento, estudante_path(current_estudante)
		end
	end
end
