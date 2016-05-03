class CreateLayoutCarteirinhas < ActiveRecord::Migration
  def change
    create_table :layout_carteirinhas do |t|
      t.attachment :anverso
      t.attachment :verso
      t.timestamps null: false
    end
  end
end
