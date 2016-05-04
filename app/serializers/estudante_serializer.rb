class EstudanteSerializer < ActiveModel::Serializer
  ActiveModel::Serializer.root = false
  attributes :type, :id, :nome, :email,:encrypted_password, :data_nascimento,
  					 :cpf, :rg_certidao, :sexo, :telefone, :celular, :foto, :xerox_rg, 
  					 :instituicao_ensino, :curso_serie, :matricula, :comprovante_matricula, 
  					 :oauth_token, :oauth_expires_at, :provider, :endereco, :carteirinha
  
 	def carteirinha
 		carteirinha = object.last_valid_carteirinha
 		carteirinha.nil? ? nil : CarteirinhaSerializer.new(carteirinha) 
 	end

 	def type
 		'estudante'
 	end

 	def cpf
 		object.cpf.to_i
 	end

 	def rg_certidao
 		object.rg_certidao.to_i
 	end

end