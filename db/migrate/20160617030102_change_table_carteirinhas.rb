class ChangeTableCarteirinhas < ActiveRecord::Migration
  def change
  	rename_column :carteirinhas, :numero_boleto, :status_pagamento	
  	add_column :carteirinhas, :transaction_id, :string
  end
end
