class ChangeEntidade < ActiveRecord::Migration
  def change
  	remove_column :entidades, :authority_key_identifier
  	rename_column :entidades, :crl_dist_points, :usuario
  	rename_column :entidades, :authority_info_access, :token_certificado
  	rename_column :entidades, :representatividade, :url_certificado
  end
end
