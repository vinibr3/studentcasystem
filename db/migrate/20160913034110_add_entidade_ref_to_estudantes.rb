class AddEntidadeRefToEstudantes < ActiveRecord::Migration
  def change
    add_reference :estudantes, :entidade, index: true, foreign_key: true
  end
end
