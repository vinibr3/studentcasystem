class CreateNoticias < ActiveRecord::Migration
  def change
    create_table :noticias do |t|
      t.attachment :foto
      t.string     :titulo
      t.string     :autor
      t.text       :body

      t.timestamps null: false
    end
  end
end
