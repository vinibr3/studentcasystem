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

ActiveRecord::Schema.define(version: 20160531181522) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "nome"
    t.string   "email",                            default: "",  null: false
    t.string   "usuario"
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
    t.string   "super_admin",            limit: 1, default: "0", null: false
    t.string   "status",                 limit: 1, default: "1", null: false
    t.string   "encrypted_password",               default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

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
    t.string   "status_versao_impressa", null: false
    t.string   "foto_file_name"
    t.string   "foto_content_type"
    t.integer  "foto_file_size"
    t.datetime "foto_updated_at"
    t.text     "certificado"
    t.integer  "estudante_id"
    t.integer  "layout_carteirinha_id"
    t.string   "alterado_por"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "valor"
    t.string   "forma_pagamento"
    t.string   "numero_boleto"
  end

  add_index "carteirinhas", ["estudante_id"], name: "index_carteirinhas_on_estudante_id", using: :btree
  add_index "carteirinhas", ["layout_carteirinha_id"], name: "index_carteirinhas_on_layout_carteirinha_id", using: :btree

  create_table "entidades", force: :cascade do |t|
    t.string   "nome"
    t.string   "sigla"
    t.string   "email"
    t.string   "cnpj"
    t.string   "chave_privada_file_name"
    t.string   "chave_privada_content_type"
    t.integer  "chave_privada_file_size"
    t.datetime "chave_privada_updated_at"
    t.string   "password"
    t.string   "common_name_certificado"
    t.string   "organizational_unit"
    t.string   "valor_carteirinha"
    t.string   "frete_carteirinha"
    t.string   "telefone"
    t.string   "logradouro"
    t.string   "numero"
    t.string   "complemento"
    t.string   "setor"
    t.string   "cep"
    t.string   "cidade"
    t.string   "uf"
    t.string   "nome_presidente"
    t.string   "email_presidente"
    t.string   "cpf_presidente"
    t.string   "rg_presidente"
    t.string   "expedidor_rg_presidente"
    t.string   "uf_expedidor_rg_presidente"
    t.date     "data_nascimento_presidente"
    t.string   "sexo_presidente"
    t.string   "celular_presidente"
    t.string   "telefone_presidente"
    t.string   "logradouro_presidente"
    t.string   "numero_presidente"
    t.string   "complemento_presidente"
    t.string   "cep_presidente"
    t.string   "cidade_presidente"
    t.string   "uf_presidente"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "authority_key_identifier"
    t.string   "crl_dist_points"
    t.string   "url_qr_code"
    t.string   "authority_info_access"
  end

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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "estudantes", ["confirmation_token"], name: "index_estudantes_on_confirmation_token", unique: true, using: :btree
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
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "nome_posx"
    t.integer  "nome_posy"
    t.integer  "instituicao_ensino_posx"
    t.integer  "instituicao_ensino_posy"
    t.integer  "escolaridade_posx"
    t.integer  "escolaridade_posy"
    t.integer  "curso_posx"
    t.integer  "curso_posy"
    t.integer  "data_nascimento_posx"
    t.integer  "data_nascimento_posy"
    t.integer  "rg_posx"
    t.integer  "rg_posy"
    t.integer  "cpf_posx"
    t.integer  "cpf_posy"
    t.integer  "codigo_uso_posx"
    t.integer  "codigo_uso_posy"
    t.integer  "nao_depois_posx"
    t.integer  "nao_depois_posy"
    t.integer  "qr_code_posx"
    t.integer  "qr_code_posy"
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

end
