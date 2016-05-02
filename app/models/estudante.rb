
class Estudante < ActiveRecord::Base
	has_many :carteirinha
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
		   :recoverable, :rememberable, :trackable, :validatable,
		   :omniauthable, :omniauth_providers => [:facebook]

	has_attached_file :foto
	has_attached_file :comprovante_matricula
	has_attached_file :xerox_rg     

	FILES_NAME_PERMIT = [/png\Z/, /jpe?g\Z/, /pdf\Z/]
	FILES_CONTENT_TYPE = ['image/jpeg', 'image/png', 'application/pdf']

	# expressões regulares
	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	STRING_REGEX = /\A[a-z A-Z]+\z/

	before_create :create_oauth_token

	# validações
	validates :nome, length: { maximum: 70, too_long: "Máximo de 70 caracteres permitidos!"}, 
	                 		   format:{with: STRING_REGEX, message:"Somente letras é permitido!"},
	                 		   allow_blank: true
	validates :email, uniqueness: {message: "Email já utilizado!"}, format: {with: EMAIL_REGEX , on: :create}
	validates :sexo, inclusion: %w(M F), allow_blank: true
	validates :telefone, length:{in: 10..11}, numericality: true, allow_blank: true
	validates :logradouro, length:{maximum: 50}, allow_blank: true
	validates :complemento, length:{maximum: 50}, allow_blank: true
	validates :setor, length:{maximum: 50}, allow_blank: true
	validates :cep, length:{is: 8}, numericality: true, allow_blank: true
	validates :cidade, length:{maximum: 30}, format:{with: STRING_REGEX}, allow_blank: true
	validates :estado, length:{is: 2}, format:{with: STRING_REGEX}, allow_blank: true
	validates :instituicao_ensino, length:{maximum: 50}, allow_blank: true
	validates :curso_serie, length:{maximum: 30}, allow_blank: true
	validates :matricula, length:{maximum: 30}, allow_blank: true
	validates :celular, length:{in: 10..11}, numericality: true, allow_blank: true
	validates :numero, length:{maximum: 5}, numericality: true, allow_blank: true
	validates :rg_certidao, numericality: true, allow_blank: true
	validates_attachment_size :foto, :less_than => 1.megabytes
	validates_attachment_size :xerox_rg, :less_than => 1.megabytes
	validates_attachment_size :comprovante_matricula, :less_than => 1.megabytes
	validates_attachment_file_name :foto, :matches => [/png\Z/, /jpe?g\Z/]
	validates_attachment_file_name :comprovante_matricula, :matches=> FILES_NAME_PERMIT
	validates_attachment_file_name :xerox_rg, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :foto, :content_type=> ['image/png', 'image/jpeg']
	validates_attachment_content_type :comprovante_matricula, :content_type=> FILES_CONTENT_TYPE
	validates_attachment_content_type :xerox_rg, :content_type=> FILES_CONTENT_TYPE
    # validates_associated :carteirinha, allow_blank: true

	public
		def carteirinha_vence_em dias
			if !self.carteirinha.nil?
				self.carteirinha.last.dias_validade <= dias 	
			else
				raise "Não há carteirinhas."
			end
		end

		def tem_carteirinha
			!self.carteirinha.last.nil?
		end

		def email_less_domain 
			string_to_substring(self.email, '@')
		end

		def first_name 
			string_to_substring(self.nome, " ")
		end

		def atributos_em_branco
			atributos = [:nome, :email, :cpf, :rg_certidao, :data_nascimento, :sexo, :telefone, 
									 :logradouro, :complemento, :setor, :cep, :cidade, :estado, :instituicao_ensino, 
									 :curso_serie, :matricula, :foto_file_name, :comprovante_matricula_file_name, 
									 :xerox_rg_file_name, :celular, :numero, :oauth_token]
			atributos_em_branco = Array.new
			atributos.each do |atributo|
				if self[atributo].nil?
					atributos_em_branco.push(atributo)
				end 
			end
			atributos_em_branco
		end
		
	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |estudante|
			estudante.provider = auth.provider
			estudante.uid = auth.uid
			estudante.nome = auth.info.name
			estudante.email = auth.info.email
			estudante.sexo = auth.extra.gender.slice(0).upcase unless auth.extra.gender != ('male'||'female')
			estudante.password = Devise.friendly_token[0,20]
		end
	end

	def self.new_with_session(params, session)
		if session["devise.estudante_attributes"]
			new(session["devise.estudante_attributes"], without_protection: true) do |estudante|
				estudante.attributes = params
				estudante.valid?
			end
		else
			super
		end	
	end

	def last_valid_carteirinha
	 	carteirinha = self.carteirinha.last
	 	if !carteirinha.nil?
	 		carteirinha.valid ? carteirinha : nil
	 	end
	 	carteirinha 
	end

	def self.koala(access_token)
		facebook = Koala::Facebook::API.new(access_token, ENV['FACEBOOK_APP_SECRET'])
		auth = facebook.get_object("me?fields=id,name,email,birthday,gender,location,education")
	end

	def self.from_koala(auth)
		where(email: auth["email"]).first_or_create do |estudante|
			estudante.uid = auth["id"] if auth.has_key?('id')
			estudante.email = auth["email"] if auth.has_key?('email')
			estudante.nome = auth["name"] if auth.has_key?('name') 
			estudante.data_nascimento = config_date(auth["birthday"]) if auth.has_key?('birthday')
			estudante.sexo =  auth["gender"].slice(0).upcase if auth["gender"] == ('female' || 'male')
			estudante.provider = 'facebook' 
			estudante.cidade = auth["location"]['name'] if auth.has_key?('location')
			estudante.instituicao_ensino = education_last(auth["education"]) if auth.has_key?('education')
			estudante.password = Devise.friendly_token
		end
	end

	def self.first_or_create_from_koala(access_token)
		auth = koala(access_token)
		estudante = from_koala(auth)
	end

	def config_date(auth)
		birthday = auth.gsub('/','-') 
		birthday = Date.strptime(birthday, '%m-%d-%Y').to_time
	end

	def education_last(education)
			array = education.to_a
			array[array.length-1]["name"]
	end

	def dados_pessoais
		array = Array.new
		array << self.data_nascimento
		array << self.cpf
		array << self.matricula
		array << self.rg_certidao
		array
	end

	def dados_estudantis
		array = Array.new
		array << self.instituicao_ensino
		array << self.periodo
		array << self.curso_serie
		array << self.cidade
		array << self.uf
		array
	end

	protected
		def endereco
	 		endereco = Hash.new
	 		endereco['logradouro'] = self[:logradouro]
	 		endereco['numero'] = self[:numero].to_i
	 		endereco['complemento'] = self[:complemento]
	 		endereco['estado'] = self[:estado]
	 		endereco['cidade'] = self[:cidade]
	 		endereco['cep'] = self[:cep].to_i
	 		endereco['uf'] = self[:estado]
	 		endereco
	 	end

	private
		def string_to_substring(string , char)
			string.from(0).to(string.index(char).to_i - 1)
		end

		def create_oauth_token
			begin
				self.oauth_token = Devise.friendly_token(50)
			end while self.class.exists?(oauth_token: oauth_token)
		end
end