class CreateEstudantes < ActiveRecord::Migration
  def change
    create_table :estudantes do |t|
   		t.string :nome
    	t.string :email,                              default: "", null: false
    	t.string :cpf
    	t.string :rg
    	t.string :expedidor_rg
    	t.string :uf_expedidor_rg
    	t.date   :data_nascimento
    	t.string :sexo
    	t.string :celular
    	t.string :telefone
    	t.string :logradouro
    	t.string :numero
    	t.string :complemento
    	t.string :setor
    	t.string :cep
    	t.string :cidade
    	t.string :uf
    	t.string :instituicao_ensino
    	t.string :curso_serie
    	t.string :escolaridade
    	t.string :matricula
    	t.string :cidade_inst_ensino
    	t.string :uf_inst_ensino
    	t.string   :foto_file_name
    	t.string   :foto_content_type
    	t.integer  :foto_file_size
    	t.datetime :foto_updated_at
    	t.string   :comprovante_matricula_file_name
    	t.string   :comprovante_matricula_content_type
    	t.integer  :comprovante_matricula_file_size
    	t.datetime :comprovante_matricula_updated_at
    	t.string   :xerox_rg_file_name
    	t.string   :xerox_rg_content_type
    	t.integer  :xerox_rg_file_size
    	t.datetime :xerox_rg_updated_at
        t.string   :chave_acesso
    	t.string   :provider
    	t.string   :uid
    	t.string   :oauth_token
    	t.datetime :oauth_expires_at
      	t.timestamps null: false
    end

    add_index :estudantes, :email,                unique: true
  
  end
end
