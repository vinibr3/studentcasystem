class AddCidadeToEstudante < ActiveRecord::Migration
  def change
    add_reference :estudantes, :cidade, index: true, foreign_key: true
  end
end
