class CarteirinhaSerializer < ActiveModel::Serializer
	ActiveModel::Serializer.root = false
	
	attributes :type, :id, :nome, :instituicao_ensino, :curso_serie, 
			   :matricula, :rg, :data_nascimento, :cpf, :expedidor_rg,
			   :numero_serie, :qr_code, :status_versao_impressa,
			   :escolaridade, :cidade_inst_ensino, :uf_inst_ensino, 
			   :nao_antes, :nao_depois

	def type
		'carteirinha'
	end

	def data_nascimento
		self.object.data_nascimento
	end

	def expedidor_rg
		self.object.expedidor_rg.concat(self.object.uf_expedidor_rg)
	end

end