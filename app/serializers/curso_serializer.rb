class CursoSerializer < ActiveModel::Serializer
  attributes :id, :nome, :escolaridade

  def escolaridade
  	object.escolaridade.nome
  end
  
end
