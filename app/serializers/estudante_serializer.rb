class EstudanteSerializer < ActiveModel::Serializer
  ActiveModel::Serializer.root = false
  attributes :type, :id, :nome, :email,:encrypted_password, :data_nascimento,
  			 :cpf, :rg, :sexo, :telefone, :celular, :foto_file_name, :xerox_rg_file_name, 
  			 :xerox_cpf_file_name,:instituicao_ensino, :curso, :matricula, 
  			 :comprovante_matricula_file_name,:oauth_token, :oauth_expires_at, 
  			 :provider, :endereco, :carteirinha_valida

 	def carteirinha_valida
 		carteirinha = object.last_valid_carteirinha
 		carteirinha.nil? ? nil : CarteirinhaSerializer.new(carteirinha) 
 	end

 	def type
 		'estudante'
 	end

 	def cpf
 		object.cpf.to_i
 	end

 	def rg
 		object.rg.to_i
 	end

 	def instituicao_ensino
 		InstituicaoEnsinoSerializer.new(object.instituicao_ensino)
 	end

 	def curso
 		CursoSerializer.new(object.curso)
 	end

end