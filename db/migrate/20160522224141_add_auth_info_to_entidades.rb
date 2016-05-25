class AddAuthInfoToEntidades < ActiveRecord::Migration
  def change
    add_column :entidades, :authority_info_access, :string
  end
end
