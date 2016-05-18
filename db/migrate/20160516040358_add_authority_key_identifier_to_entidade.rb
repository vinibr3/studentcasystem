class AddAuthorityKeyIdentifierToEntidade < ActiveRecord::Migration
  def change
    add_column :entidades, :authority_key_identifier, :text
    add_column :entidades, :crl_dist_points, :string
  end
end
