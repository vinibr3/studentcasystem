class AddValorToCarteirinhas < ActiveRecord::Migration
  def change
    add_column :carteirinhas, :valor, :integer
    add_column :carteirinhas, :forma_pagamento, :string
    add_column :carteirinhas, :numero_boleto, :string
  end
end
