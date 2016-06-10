class Entidade < ActiveRecord::Base
	has_attached_file :logo
	has_attached_file :configuracao
	has_many :instituicao_ensinos

	FILES_NAME_PERMIT = [/png\Z/, /jpe?g\Z/]
	FILES_CONTENT_TYPE = ['image/jpeg', 'image/png']

	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	STRING_REGEX = /\A[a-z A-Z]+\z/
	LETRAS = /[A-Z a-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ]+/

	#dados entidade
	validates :nome, length: { maximum: 70, too_long: "Máximo de #{count} caracteres permitidos."}, 
	                 format: {with: LETRAS, message:"Somente letras é permitidos."}
	validates :sigla, length: {maximum: 10, too_long: "Máximo de #{count} caracteres permitidos."},
					  format: {with: STRING_REGEX, message: "Somente letras é permitido"}, allow_blank: true				  
	validates :email, uniqueness: {message: "Email já utilizado"}, format: {with: EMAIL_REGEX, on: :create}
	validates :cnpj, numericality: true, length: {is: 14, wrong_length: "14 caracteres."}
	validates :valor_carteirinha, numericality: true
	validates :frete_carteirinha, numericality: true, allow_blank: true
	validates :telefone, numericality: true, length: {in: 10..11, wrong_format: "Mínimo de 10 e máximo 11 caracteres permitidos."}, allow_blank: true
    validates :logradouro, length:{maximum: 50, too_long:"Máximo de #{count} caracteres permitidos."}, allow_blank: true
    validates :numero, numericality: true, length: {maximum: 10, too_long: "Máximo de #{count} caracteres permitidos."}, allow_blank: true  
    validates :complemento, length: {maximum: 50, too_long: "Máximo de #{count} caracteres permitidos."}, allow_blank: true
	validates :setor, length: {maximum: 30,too_long: "Máximo de #{count} caracteres permitidos."}, allow_blank: true
	validates :cep, length:{is: 8, wrong_length: "#{count} caracteres."}, numericality: true, allow_blank: true
	validates :cidade, length: {maximum: 50, too_long: "Máximo de #{count} caracteres permitidos."}, allow_blank: true
	validates :uf, length: {is: 2, wrong_length: "Máximo de 2 caracteres permitidos."}, format: {with: STRING_REGEX}, allow_blank: true
	validates_attachment_size :logo, :less_than => 1.megabytes
	validates_attachment_file_name :logo, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :logo, :content_type => FILES_CONTENT_TYPE

	validates_attachment_size :configuracao, :less_than => 5.megabytes
	validates_attachment_file_name :configuracao, :matches => [/json\Z/]
	validates_attachment_content_type :configuracao, :content_type => ["application/octet-stream", "text/plain"]
	
	#dados presidente da entidade
	validates :nome_presidente, length: { maximum: 70, too_long: "Máximo de #{count} caracteres permitidos!"}, 
	                 format: {with: LETRAS, message:"Somente letras é permitido!"}
	validates :email_presidente, uniqueness: {message: "Email já utilizado"}, format: {with: EMAIL_REGEX, on: :create}
	validates :cpf_presidente, numericality: true, length:{is: 11, wrong_length: "Necessário 11 caracteres."}, allow_blank: true
	validates :rg_presidente, numericality: true, allow_blank: true
	validates :expedidor_rg_presidente, length:{maximum: 10, too_long:"Máximo de #{count} caracteres permitidos!"}, 
							 format:{with: STRING_REGEX, message: "Somente letras é permitido!"}, allow_blank: true
	validates :uf_expedidor_rg_presidente, length:{is: 2, wrong_message: "#{count} caracteres permitidos."}, format:{with:STRING_REGEX}, allow_blank: true
	validates :celular_presidente, length:{in: 10..11}, numericality: true, allow_blank: true
	validates :telefone_presidente, length:{in: 10..11}, numericality: true, allow_blank: true
	validates :sexo_presidente, inclusion: %w(Masculino Feminino), allow_blank: true
	validates :complemento_presidente, length: {maximum: 50, too_long:"Máximo de #{count} caracteres permitidos."}, allow_blank: true
	validates :logradouro_presidente, length:{maximum: 50, too_long:"Máximo de #{count} caracteres permitidos."}, allow_blank: true
	validates :numero_presidente, numericality: true, length: {maximum: 10, too_long: "Máximo de #{count} caracteres permitidos."}, allow_blank: true  	
	validates :cep_presidente, length:{is: 8, wrong_length: "8 caracteres."}, numericality: true, allow_blank: true
	validates :cidade_presidente, length: {maximum: 50, too_long: "Máximo de #{count} caracteres permitidos."}, allow_blank: true
	validates :uf_presidente, length: {is: 2, wrong_length: "Máximo de 2 caracteres permitidos."}, format: {with: STRING_REGEX}, allow_blank: true

	# def configuracao_file_match_json_schema
	# 	msg = "json fora do padrão"
	# 	begin
	# 	schema = {"type"=>"object","properties"=>{"entidade"=>{"type"=>"object","properties"=>{"sigla"=>{"type"=>"string"},"instituicoes_ensino"=>{"type"=>"array","properties"=>{"nome"=>{"type"=>"string"},"cursos"=>{"type"=>"object","properties"=>{"fundamental"=>{"type"=>"array"},"medio"=>{"type"=>"array"},"superior"=>{"type"=>"array"},"pos_graduacao"=>{"type"=>"array"}}}}}}}}}
	# 	json = JSON.parse Paperclip.io_adapters.for(self.configuracao).read
	# 	errors.add(:configuracao, msg) unless JSON::Validator.validate(schema, json)
	# 	rescue JSON::ParserError
	# 		errors.add(:configuracao, msg)
	# 	end
	# end

	# def instituicoes_ensino_from_json_file
	# 	json = JSON.parse Paperclip.io_adapters.for(self.configuracao).read
	# 	instituicoes_ensino = json["entidade"]["instituicoes_ensino"].map{|instituicao| instituicao["nome"]}
	# end

	# def escolaridades_from_json_file instituicao
	# 	json = JSON.parse Paperclip.io_adapters.for(self.configuracao).read
	# 	instituicoes = json["entidade"]["instituicoes_ensino"].each{|inst| instituicao = inst if inst["nome"] == instituicao}
	# 	instituicao["cursos"].map{|k,v| k unless v.count == 0}
	# end 

	# def escolaridades_from_first_instituicao
	# 	json = JSON.parse Paperclip.io_adapters.for(self.configuracao).read
	# 	instituicao = json["entidade"]["instituicoes_ensino"][0]["nome"]
	# 	escolaridades_from_json_file instituicao
	# end

	# def cursos_from_json_file instituicao, escolaridade
	# 	json = JSON.parse Paperclip.io_adapters.for(self.configuracao).read
	# 	instituicoes = json["entidade"]["instituicoes_ensino"].each{|inst| instituicao = inst if inst["nome"] == instituicao}
	# 	instituicao["cursos"][escolaridade.to_s]
	# end

	def self.instance
		entidade = Entidade.last
		if entidade 
		   return entidade
		else
			raise "Nenhuma entidade Configurada"
		end
	end
end