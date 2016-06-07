class RenameColumnComonNameFromEntidade < ActiveRecord::Migration
  def change
  	rename_column :entidades, :common_name_certificado, :instituicao_ensino
  end
end
