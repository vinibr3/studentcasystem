class CreateCarteirinhas < ActiveRecord::Migration
  def change
    create_table :carteirinhas do |t|
    	t.string   :nome
    	t.string   :rg
    	t.string   :cpf
    	t.date     :data_nascimento
    	t.string   :matricula
    	t.string   :expeditor_rg
    	t.string   :uf_expeditor_rg
    	t.string   :instituicao_ensino
    	t.string   :cidade_inst_ensino
    	t.string   :escolaridade
    	t.string   :uf_inst_ensino
    	t.string   :curso_serie
    	t.string   :codigo_uso
    	t.string   :numero_serie
    	t.date     :nao_antes
    	t.date     :nao_depois
    	t.string   :qr_code  #
    	t.string   :status_versao_digital,             null: false
    	t.string   :status_versao_impressa,            null: false
    	t.string   :foto_file_name
    	t.string   :foto_content_type
    	t.integer  :foto_file_size
    	t.datetime :foto_updated_at
    	t.text     :certificado   #base64
    	t.references :estudante,            index: true, foreigh_key: true
    	t.references :layout_carteirinha,   index: true, foreigh_key: true
      t.timestamps null: false
    end
  end
end
