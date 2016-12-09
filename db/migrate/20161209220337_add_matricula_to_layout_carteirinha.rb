class AddMatriculaToLayoutCarteirinha < ActiveRecord::Migration
  def change
    add_column :layout_carteirinhas, :matricula_posx, :integer
    add_column :layout_carteirinhas, :matricula_posy, :integer
  end
end
