class CreateInstituicaoEnsinos < ActiveRecord::Migration
  def change
    create_table :instituicao_ensinos do |t|
      t.string :nome
      t.string :sigla
      t.string :cnpj
      t.string :logradouro
      t.string :numero
      t.string :cep
      t.string :complemento
      t.references :cidade, index: true, foreign_key: true
      t.references :estado, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
