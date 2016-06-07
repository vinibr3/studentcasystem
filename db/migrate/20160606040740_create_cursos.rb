class CreateCursos < ActiveRecord::Migration
  def change
    create_table :cursos do |t|
      t.string :nome
      t.references :escolaridade, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
