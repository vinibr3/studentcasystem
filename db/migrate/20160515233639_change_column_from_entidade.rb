class ChangeColumnFromEntidade < ActiveRecord::Migration
  def change
  	rename_column :entidades, :celular_presidete, :celular_presidente
  end
end
