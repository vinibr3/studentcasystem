class AddRepresentatividadeToEntidades < ActiveRecord::Migration
  def change
    add_column :entidades, :representatividade, :string
  end
end
