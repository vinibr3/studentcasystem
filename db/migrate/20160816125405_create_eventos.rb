class CreateEventos < ActiveRecord::Migration
  def change
    create_table :eventos do |t|
      t.string :titulo
      t.datetime :data
      t.attachment :folder
      t.string :local
      t.text :texto

      t.timestamps null: false
    end
  end
end
