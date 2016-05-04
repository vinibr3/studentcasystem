class RenameColumnExpeditorRg < ActiveRecord::Migration
  def change
  	rename_column :carteirinhas, :expeditor_rg, :expedidor_rg
  	rename_column :carteirinhas, :uf_expeditor_rg, :uf_expedidor_rg
  end
end
