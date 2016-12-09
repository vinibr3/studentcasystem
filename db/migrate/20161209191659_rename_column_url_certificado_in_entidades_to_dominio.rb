class RenameColumnUrlCertificadoInEntidadesToDominio < ActiveRecord::Migration
  def change
  	rename_column :entidades, :url_certificado, :dominio
  end
end
