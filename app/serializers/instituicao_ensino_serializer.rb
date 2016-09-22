class InstituicaoEnsinoSerializer < ActiveModel::Serializer
  attributes :id, :nome, :sigla, :cidade, :estado

  def cidade 
  	object.cidade.nome
  end

  def estado
  	object.estado.nome
  end

end
