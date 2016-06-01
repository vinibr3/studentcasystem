class AddColunsToLayoutCarteirinhas < ActiveRecord::Migration
  def change
  	add_column :layout_carteirinhas, :nome_posx, :integer
  	add_column :layout_carteirinhas, :nome_posy, :integer
  	add_column :layout_carteirinhas, :instituicao_ensino_posx, :integer
  	add_column :layout_carteirinhas, :instituicao_ensino_posy, :integer
  	add_column :layout_carteirinhas, :escolaridade_posx, :integer
  	add_column :layout_carteirinhas, :escolaridade_posy, :integer
  	add_column :layout_carteirinhas, :curso_posx, :integer
  	add_column :layout_carteirinhas, :curso_posy, :integer
  	add_column :layout_carteirinhas, :data_nascimento_posx, :integer
  	add_column :layout_carteirinhas, :data_nascimento_posy, :integer
  	add_column :layout_carteirinhas, :rg_posx, :integer
  	add_column :layout_carteirinhas, :rg_posy, :integer
  	add_column :layout_carteirinhas, :cpf_posx, :integer
  	add_column :layout_carteirinhas, :cpf_posy, :integer
  	add_column :layout_carteirinhas, :codigo_uso_posx, :integer
  	add_column :layout_carteirinhas, :codigo_uso_posy, :integer
  	add_column :layout_carteirinhas, :nao_depois_posx, :integer
  	add_column :layout_carteirinhas, :nao_depois_posy, :integer
  	add_column :layout_carteirinhas, :qr_code_posx, :integer
  	add_column :layout_carteirinhas, :qr_code_posy, :integer
  end
end
