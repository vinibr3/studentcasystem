module ApplicationHelper
	def presentation_name nome
		name=nil
		if nome.blank?
			name = current_estudante.email_less_domain
		else
			name = current_estudante.first_name
		end
		cumprimento = "Olá, #{name}"
		content_tag :li  do
			link_to cumprimento, estudante_path(current_estudante)
		end
	end
end
