class CarteirinhaSerializer < ActiveModel::Serializer
	ActiveModel::Serializer.root = false

	attributes :type, :id, :nome, :instituicao_ensino, :curso_serie, 
						 :matricula, :rg_certidao, :data_nascimento, :cpf, 
						 :validade, :foto, :numero_serie, :qr_code, 
						 :status_versao_digital, :status_versao_impressa,
						 :layout_front, :layout_back
						 
	def layout_back
		object.layout_carteirinha.layout_back
	end

	def layout_front
		object.layout_carteirinha.layout_front
	end		   

	def cpf
		object.cpf.numero
	end

	def type
		'carteirinha'
	end

end