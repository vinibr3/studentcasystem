class RemoveCidadeAndEstadoFromEstudante < ActiveRecord::Migration
  def change
    remove_column :estudantes, :cidade, :string
    remove_column :estudantes, :uf, :string
  end
end
