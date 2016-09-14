class AddEntidadeRefToLayoutCarteirinhas < ActiveRecord::Migration
  def change
    add_reference :layout_carteirinhas, :entidade, index: true, foreign_key: true
  end
end
