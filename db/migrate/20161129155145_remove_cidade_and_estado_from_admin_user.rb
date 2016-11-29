class RemoveCidadeAndEstadoFromAdminUser < ActiveRecord::Migration
  def change
    remove_column :admin_users, :cidade, :string
    remove_column :admin_users, :uf, :string
  end
end
