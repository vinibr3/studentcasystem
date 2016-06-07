class RemoveColumnEscolaridadeFromEstudantes < ActiveRecord::Migration
  def change
  	remove_column :estudantes, :escolaridade
  end
end
