class AddEntidadeRefToCarteirinhas < ActiveRecord::Migration
  def change
    add_reference :carteirinhas, :entidade, index: true, foreign_key: true
  end
end
