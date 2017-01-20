class AddTamanhoFonteToLayoutCarteirinhas < ActiveRecord::Migration
  def change
    add_column :layout_carteirinhas, :tamanho_fonte, :integer
  end
end
