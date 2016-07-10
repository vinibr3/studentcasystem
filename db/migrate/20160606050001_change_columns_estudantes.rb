class ChangeColumnsEstudantes < ActiveRecord::Migration
  def change
  	remove_column :estudantes, :cidade_inst_ensino
  	remove_column :estudantes, :uf_inst_ensino
  end
end
