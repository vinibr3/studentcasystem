class RemoveEntidadeFromInstituicaoEnsino < ActiveRecord::Migration
  def change
    remove_column :instituicao_ensinos, :entidade_id, :reference
  end
end
