class ChangeColumnValorFromEntidade < ActiveRecord::Migration
  def change
  	change_column :carteirinhas, :valor, :string
  end
end
