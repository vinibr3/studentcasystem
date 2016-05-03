class CreateSolicitacaos < ActiveRecord::Migration
  def change
    create_table :solicitacaos do |t|

      t.timestamps null: false
    end
  end
end
