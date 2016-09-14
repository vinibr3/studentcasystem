class AddAuthInfoAccessToEntidades < ActiveRecord::Migration
  def change
    add_column :entidades, :auth_info_access, :string
    add_column :entidades, :crl_dist_points, :string
  end
end
