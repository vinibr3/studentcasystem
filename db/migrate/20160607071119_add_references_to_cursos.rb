class AddReferencesToCursos < ActiveRecord::Migration
  def change
    add_reference :cursos, :instituicao_ensino, index: true, foreign_key: true
  end
end
