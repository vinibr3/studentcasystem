class Carteirinha < ActiveRecord::Base

	belongs_to :estudante
	belongs_to :layout_carteirinha

	has_attached_file :foto
	
	STATUS_VERSAO_DIGITAL = ["Pagamento", "Documentação", "Download", "Baixada"]
	STATUS_VERSAO_IMPRESSA = ["Pagamento", "Documentação", "Enviada", "Entregue"]
	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
	STRING_REGEX = /\A[a-z A-Z]+\z/
	ALFANUMERICO = /\A[a-z A-Z]+\z/

	@@VALOR = 20;
	@@FRETE = 6.5;

	before_create :config_attributes
	before_validation :set_status_inicial

	# validações
	validates :nome, length: { maximum: 70, too_long: "Máximo de 70 caracteres permitidos"}, format:{with: STRING_REGEX, message:"Somente letras é permitido!"}
	validates :instituicao_ensino, length:{maximum: 50}
	validates :curso_serie, length:{maximum: 30}
	validates :matricula, numericality: true, length:{maximum: 30}, allow_blank: true
	validates :rg, numericality: {only_integer: true}
	validates :instituicao_ensino, length:{maximum: 50, too_long: "Máximo de 50 caracteres permitidos!."}, allow_blank: true
	validates :cidade_inst_ensino, length:{maximum: 30, too_long: too_long:"Máximo de 70 carectetes é permitidos!"}, format:{with: STRING_REGEX}, allow_blank: true
	validates :curso_serie, length:{maximum: 40, too_long: "Máximo de 40 caracteres permitidos!."}, allow_blank: true
	validates :codigo_uso, allow_blank: true;
	validates :termos, acceptance: true
	validates :versao_digital, length:{is: 1}, inclusion:{in: %w(0 1)}
	validates :versao_impressa, length:{is: 1}, inclusion:{in: %w(0 1)}
	validates :status_versao_impressa, inclusion:{in: %w(Pagamento Documentação Enviada Entregue)}
	validates :status_versao_digital, inclusion:{in: %w(Pagamento Documentação Download Baixada)}
	validates :valor, length:{maximum: 4}, numericality: {only_float: true}
	validates :numero_serie, numericality: true, uniqueness: true
	validates :cpf, numericality: true, length:{is: 11, too_long: "Necessário 11 caracteres.",  too_short: "Necessário 11 caracteres."}, allow_blank: true
	validates :certificado, format:{with: [:alnum:]}
	validates :expedidor_rg, length:{maximum: 10, too_long:"Máximo de 10 caracteres permitidos!"}, 
							 format:{with:STRING_REGEX, message: "Somente letras é permitido!"}, allow_blank: true
	validates :uf_expedidor_rg, length:{is: 2}, format:{with:STRING_REGEX}, allow_blank: true
	validates :uf, length:{is: 2}, format:{with:STRING_REGEX}, allow_blank: true
	validates :uf_inst_ensino, length:{is: 2}, format:{with:STRING_REGEX}, allow_blank: true
	validates :escolaridade, length:{maximum: 30, too_long: "Máximo de 30 caracteres permitidos!"}
							 format:{with:STRING_REGEX, message:"Somente letras é permitido"}, allow_blank: true
	validates_attachment_size :foto, :less_than => 1.megabytes
	validates_attachment_file_name :foto, :matches => [/png\Z/, /jpe?g\Z/]
	validates_attachment_content_type :foto, :content_type => ['image/jpeg', 'image/png', 'application/pdf']


	def self.VALOR
		@@VALOR
	end

	def self.FRETE
		@@FRETE
	end

	def layout
		if layout_carteirinha.nil? 
			LayoutCarteirinha::instance.layout 
		else
			layout_carteirinha.layout_front
		end
	end

	def dias_validade 
		seconds = self.validade - Time.now.to_date
		dias = seconds*1000/24*60*60
	end

	def valid
		dias_validade >= 0
	end

	def em_solicitacao?
		if valid
			if self.status_versao_impressa == STATUS_VERSAO_IMPRESSA[3] || self.status_versao_digital == STATUS_VERSAO_DIGITAL[3]
				return false
			else
				return true
			end
		else
			return false
		end
	end

	def status_versao_impressa_to_i
		STATUS_VERSAO_IMPRESSA.length.times do |i|
			if STATUS_VERSAO_IMPRESSA[i] == self[:status_versao_impressa]
				return i
			end
		end
	end

	def status_versao_digital_to_i
		STATUS_VERSAO_DIGITAL.length.times do |i|
			if STATUS_VERSAO_DIGITAL[i] == self[:status_versao_digital]
				return i
			end
		end
	end

	protected
		def vencida
			self.vencimento == "1"	
		end

		def set_status_inicial
			self.status_versao_impressa = STATUS_VERSAO_IMPRESSA[0] if !self.versao_impressa.nil?  
			self.status_versao_digital = STATUS_VERSAO_DIGITAL[0] if !self.versao_digital.nil?
		end

		def config_attributes
			self.layout_carteirinha_id = LayoutCarteirinha::instance.id
			self.validade = Time.new(Time.new.year+1,3,31).to_date
			self.numero_serie = (Time.new - Time.new(2015,1,1)).to_i
			self.qr_code = "http://localhost:3000/carteirinhas/".concat(self.numero_serie)
		end

end
