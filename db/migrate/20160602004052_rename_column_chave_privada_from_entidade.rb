class RenameColumnChavePrivadaFromEntidade < ActiveRecord::Migration
  def change
  	rename_column :entidades, :chave_privada_file_name, :logo_file_name
  	rename_column :entidades, :chave_privada_content_type, :logo_content_type
  	rename_column :entidades, :chave_privada_file_size, :logo_file_size
  	rename_column :entidades, :chave_privada_updated_at, :logo_updated_at
  end
end
