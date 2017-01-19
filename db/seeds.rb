require 'net/http'
require 'net/https' # for ruby 1.8.7
require 'json'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(nome: "Super Admin", email: 'doti@doti.com.br', password: 'admindoti', password_confirmation: 'admindoti', 
                  super_admin: "1", usuario: "superadmin") unless AdminUser.exists?(email: 'doti@doti.com.br')

 module BRPopulate
    def self.estados
      http = Net::HTTP.new('raw.githubusercontent.com', 443); http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      JSON.parse http.get('/celsodantas/br_populate/master/states.json').body
    end

    def self.capital?(cidade, estado)
      cidade["name"] == estado["capital"]
    end

    def self.populate
      estados.each do |estado|
        estado_obj = Estado.new(:sigla => estado["acronym"], :nome => estado["name"])
        estado_obj.save
        
        estado["cities"].each do |cidade|
          c = Cidade.new
          c.nome = cidade["name"]
          c.estado = estado_obj
          c.capital = capital?(cidade, estado)
          c.save
        end
      end
    end
  end

 BRPopulate.populate
#Entidade
entidade = Entidade.create!(nome: "Entidade", email: "contato@entidade.com", cnpj:"12345678912345", sigla: "ENT",
                            valor_carteirinha: 25, cep: "11111111", nome_presidente: "Presidente", 
                            email_presidente: "email@email.com", dominio: "https://www.entidade.org.br", auth_info_access: "https://www.entidade.com.br", crl_dist_points: "https://entidade.com.br") unless Entidade.exists?(nome: "Entidade")
# Instituições de Ensino
# inst = InstituicaoEnsino.create!(nome: "Universidade Estadual do Piauí", sigla: "UESPI", cnpj: "12345678912345", logradouro: "Rua 1", 
#                            complemento: "jardins", numero: "123", cep:"74916170", cidade: Cidade.find(3103), estado: Estado.find(17), entidade: entidade)

 #escolaridades
 @ensino_infantil = Escolaridade.create!(nome: "ENSINO INFANTIL")
 ensino_fundamental = Escolaridade.create!(nome: "ENSINO FUNDAMENTAL")
 ensino_medio = Escolaridade.create!(nome: "ENSINO MÉDIO")
 ensino_tecnico_medio = Escolaridade.create!(nome: "ENSINO TÉCNICO/PROFISIONALIZANTE")
 graduacao = Escolaridade.create!(nome: "GRADUAÇÃO")
 pos_graduacao = Escolaridade.create!(nome: "PÓS-GRADUAÇÃO")
 mestrado = Escolaridade.create!(nome: "MESTRADO")
 doutorado = Escolaridade.create!(nome: "DOUTORADO")
 pos_doutorado = Escolaridade.create!(nome: "PÓS-DOUTORADO")

 #Cursos / Ensino Infantil
 bercario = Curso.create!(nome: "BERÇARIO", escolaridade: @ensino_infantil)
 maternal = Curso.create!(nome: "MATERNAL", escolaridade: @ensino_infantil)
 3.times do |i|
   Curso.create!(nome: "PRE ".concat((i+1).to_s), escolaridade: @ensino_infantil)
 end
 
 #Cursos / Ensino Fundamental
 9.times do |i|
  Curso.create!(nome: (i+1).to_s.concat("º ANO"), escolaridade: ensino_fundamental)
 end

 #Cursos / Ensino Médio
 3.times do |i|
  Curso.create!(nome: (i+1).to_s.concat("º ANO"), escolaridade: ensino_medio)
 end

 # #Cursos / Graduação
 #  curso1 = Curso.create!(nome: "Agronomia", escolaridade: graduacao)
 #  curso2 = Curso.create!(nome: "Administração", escolaridade: graduacao)
 #  curso3 = Curso.create!(nome: "Engenharia Civíl", escolaridade: graduacao)
 #  curso4 = Curso.create!(nome: "Ciência Da Computação", escolaridade: graduacao)
 #  Curso.create!(nome: "Engenharia Civíl", escolaridade: graduacao)
 #  Curso.create!(nome: "Ciência Da Computação", escolaridade: graduacao)
 # #Cursos / Pós-graduação
 #  Curso.create!(nome: "Agronomia", escolaridade: pos_graduacao)
 #  Curso.create!(nome: "Administração", escolaridade: pos_graduacao)
 #  Curso.create!(nome: "Engenharia Civíl", escolaridade: pos_graduacao)
 #  Curso.create!(nome: "Ciência Da Computação", escolaridade: pos_graduacao)
 # #Cursos / Mestrado
 #  Curso.create!(nome: "Agronomia", escolaridade: mestrado)
 #  Curso.create!(nome: "Administração", escolaridade: mestrado)
 #  Curso.create!(nome: "Engenharia Civíl", escolaridade: mestrado)
 # #Cursos / Doutorado
 #  Curso.create!(nome: "Agronomia", escolaridade: doutorado)
 #  Curso.create!(nome: "Administração", escolaridade: doutorado)
 # #Cursos / Pós-Doutorado
 #  Curso.create!(nome: "Agronomia", escolaridade: pos_doutorado)