class CreateAvisos < ActiveRecord::Migration
  def change
    create_table :avisos do |t|
      t.text :aviso

      t.timestamps null: false
    end
  end
end
