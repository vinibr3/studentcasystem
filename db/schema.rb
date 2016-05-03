# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160503174037) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carteirinhas", force: :cascade do |t|
    t.string   "nome"
    t.string   "rg"
    t.string   "cpf"
    t.date     "data_nascimento"
    t.string   "matricula"
    t.string   "expedidor_rg"
    t.string   "uf_expedidor_rg"
    t.string   "instituicao_ensino"
    t.string   "cidade_inst_ensino"
    t.string   "escolaridade"
    t.string   "uf_inst_ensino"
    t.string   "curso_serie"
    t.string   "codigo_uso"
    t.string   "numero_serie"
    t.date     "nao_antes"
    t.date     "nao_depois"
    t.string   "qr_code"
    t.string   "status_versao_digital",  null: false
    t.string   "status_versao_impressa", null: false
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
    t.text     "certificado"
    t.integer  "estudante_id"
    t.integer  "layout_carteirinha_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "carteirinhas", ["estudante_id"], name: "index_carteirinhas_on_estudante_id", using: :btree
  add_index "carteirinhas", ["layout_carteirinha_id"], name: "index_carteirinhas_on_layout_carteirinha_id", using: :btree

  create_table "estudantes", force: :cascade do |t|
    t.string   "nome"
    t.string   "email",                              default: "", null: false
    t.string   "cpf"
    t.string   "rg"
    t.string   "expedidor_rg"
    t.string   "uf_expedidor_rg"
    t.date     "data_nascimento"
    t.string   "sexo"
    t.string   "celular"
    t.string   "telefone"
    t.string   "logradouro"
    t.string   "numero"
    t.string   "complemento"
    t.string   "setor"
    t.string   "cep"
    t.string   "cidade"
    t.string   "uf"
    t.string   "instituicao_ensino"
    t.string   "curso_serie"
    t.string   "escolaridade"
    t.string   "matricula"
    t.string   "cidade_inst_ensino"
    t.string   "uf_inst_ensino"
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
    t.string   "comprovante_matricula_file_name"
    t.string   "comprovante_matricula_content_type"
    t.integer  "comprovante_matricula_file_size"
    t.datetime "comprovante_matricula_updated_at"
    t.string   "xerox_rg_file_name"
    t.string   "xerox_rg_content_type"
    t.integer  "xerox_rg_file_size"
    t.datetime "xerox_rg_updated_at"
    t.string   "chave_acesso"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "estudantes", ["email"], name: "index_estudantes_on_email", unique: true, using: :btree
  add_index "estudantes", ["reset_password_token"], name: "index_estudantes_on_reset_password_token", unique: true, using: :btree

  create_table "layout_carteirinhas", force: :cascade do |t|
    t.string   "anverso_file_name"
    t.string   "anverso_content_type"
    t.integer  "anverso_file_size"
    t.datetime "anverso_updated_at"
    t.string   "verso_file_name"
    t.string   "verso_content_type"
    t.integer  "verso_file_size"
    t.datetime "verso_updated_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "noticias", force: :cascade do |t|
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
    t.string   "titulo"
    t.string   "autor"
    t.text     "body"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "solicitacaos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
