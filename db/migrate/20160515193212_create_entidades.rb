class CreateEntidades < ActiveRecord::Migration
  def change
    create_table :entidades do |t|
      t.string :nome
      t.string :sigla
      t.string :email
      t.string :cnpj
      t.attachment :chave_privada
      t.string :password
      t.string :common_name_certificado
      t.string :organizational_unit
      t.string :valor_carteirinha
      t.string :frete_carteirinha
      t.string :telefone
      t.string :logradouro
      t.string :numero
      t.string :complemento
      t.string :setor
      t.string :cep
      t.string :cidade
      t.string :uf
      t.string :nome_presidente
      t.string :email_presidente
      t.string :cpf_presidente
      t.string :rg_presidente
      t.string :expedidor_rg_presidente
      t.string :uf_expedidor_rg_presidente
      t.date   :data_nascimento_presidente
      t.string :sexo_presidente
      t.string :celular_presidente
      t.string :telefone_presidente
      t.string :logradouro_presidente
      t.string :numero_presidente
      t.string :complemento_presidente
      t.string :cep_presidente
      t.string :cidade_presidente
      t.string :uf_presidente
      t.timestamps null: false
    end
  end
end
