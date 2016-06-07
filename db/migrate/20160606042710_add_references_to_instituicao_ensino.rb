class AddReferencesToInstituicaoEnsino < ActiveRecord::Migration
  def change
    add_reference :instituicao_ensinos, :entidade, index: true, foreign_key: true
  end
end
