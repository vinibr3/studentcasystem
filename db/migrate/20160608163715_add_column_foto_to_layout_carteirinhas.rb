class AddColumnFotoToLayoutCarteirinhas < ActiveRecord::Migration
  def change
    add_column :layout_carteirinhas, :qr_code_width,  :integer
  	add_column :layout_carteirinhas, :qr_code_height, :integer
  	add_column :layout_carteirinhas, :foto_posx,      :integer
  	add_column :layout_carteirinhas, :foto_posy,      :integer
  	add_column :layout_carteirinhas, :foto_width,     :integer
  	add_column :layout_carteirinhas, :foto_height,    :integer
  end
end
