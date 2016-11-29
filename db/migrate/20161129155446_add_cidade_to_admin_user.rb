class AddCidadeToAdminUser < ActiveRecord::Migration
  def change
    add_reference :admin_users, :cidade, index: true, foreign_key: true
  end
end
