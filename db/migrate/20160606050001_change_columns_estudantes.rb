class ChangeColumnsEstudantes < ActiveRecord::Migration
  def change
  	rename_column :estudantes, :instituicao_ensino, :instituicao_ensino_id
  	remove_column :estudantes, :cidade_inst_ensino
  	remove_column :estudantes, :uf_inst_ensino
  end
end
