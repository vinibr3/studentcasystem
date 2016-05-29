class Carteirinha < ActiveRecord::Base

	belongs_to :estudante
	belongs_to :layout_carteirinha

	has_attached_file :foto
	
	@@STATUS_VERSAO_DIGITAL = ["Pagamento", "Documentação", "Download", "Baixada"]
	@@STATUS_VERSAO_IMPRESSA = ["Pagamento", "Documentação", "Aprovada","Enviada", "Entregue"]
	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
	STRING_REGEX = /\A[a-z A-Z]+\z/
	LETRAS = /[A-Z a-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ]+/

	# validações
	validates :nome, length: { maximum: 70, too_long: "Máximo de 70 caracteres permitidos"}, format:{with: LETRAS, message:"Somente letras é permitido!"}
	validates :instituicao_ensino, length:{maximum: 50}
	validates :curso_serie, length:{maximum: 30}
	validates :matricula, numericality: true, length:{maximum: 30}, allow_blank: true
	validates :rg, numericality: {only_integer: true}
	validates :instituicao_ensino, length:{maximum: 50, too_long: "Máximo de 50 caracteres permitidos!."}, format: {with: LETRAS}, allow_blank: true
	validates :cidade_inst_ensino, length:{maximum: 30, too_long:"Máximo de 70 carectetes é permitidos!"}, format:{with: LETRAS}, allow_blank: true
	validates :curso_serie, length:{maximum: 40, too_long: "Máximo de 40 caracteres permitidos!."}, format:{with: LETRAS}, allow_blank: true
	#validates :codigo_uso, allow_blank: true
	validates :termos, acceptance: true
	validates :status_versao_impressa, inclusion:{in: %w(Pagamento Documentação Aprovada Enviada Entregue)}
	#validates :status_versao_digital, inclusion:{in: %w(Pagamento Documentação Download Baixada)}
	validates :valor, length:{maximum: 4}
	validates :numero_serie, numericality: true, uniqueness: true, allow_blank: true
	validates :cpf, numericality: true, length:{is: 11, too_long: "Necessário 11 caracteres.",  too_short: "Necessário 11 caracteres."}, allow_blank: true
	validates :expedidor_rg, length:{maximum: 10, too_long:"Máximo de 10 caracteres permitidos!"}, 
							 format:{with:STRING_REGEX, message: "Somente letras é permitido!"}, allow_blank: true
	validates :uf_expedidor_rg, length:{is: 2}, format:{with:STRING_REGEX}, allow_blank: true
	validates :uf_inst_ensino, length:{is: 2}, format:{with:STRING_REGEX}, allow_blank: true
	validates :escolaridade, length:{maximum: 30, too_long: "Máximo de 30 caracteres permitidos!"},
							 format:{with:LETRAS, message:"Somente letras é permitido"}, allow_blank: true
	validates_attachment_size :foto, :less_than => 1.megabytes
	validates_attachment_file_name :foto, :matches => [/png\Z/, /jpe?g\Z/]
	validates_attachment_content_type :foto, :content_type => ['image/jpeg', 'image/png', 'application/pdf']

	before_update :check_update_status

	def layout
		if layout_carteirinha.nil? 
			LayoutCarteirinha::instance.layout 
		else
			layout_carteirinha.layout_front
		end
	end

	def dias_validade 
		nao_depois  = self.nao_depois
		seconds = nil
		dias = nil
		if nao_depois 
			seconds = self[:nao_depois] - Time.now.to_date
			dias = seconds*1000/24*60*60
		else
			dias = 1000;
		end
		dias.days
	end

	def valid
		dias_validade >= 0
	end

	def em_solicitacao?
		if valid
			if self.status_versao_impressa == @@STATUS_VERSAO_IMPRESSA[3]
				return false
			else
				return true
			end
		else
			return false
		end
	end

	def status_versao_impressa_to_i
		@@STATUS_VERSAO_IMPRESSA.length.times do |i|
			if @@STATUS_VERSAO_IMPRESSA[i] == self[:status_versao_impressa]
				return i
			end
		end
	end

	def check_update_status
		if self.status_versao_impressa == "Aprovada" 
            self.layout_carteirinha_id = LayoutCarteirinha.last_layout_id                 if self.layout_carteirinha_id.blank?
            self.nao_antes = Time.new                                                     if self.nao_antes.blank?
            self.nao_depois = Time.new(Time.new.year+1, 3, 31).to_date                    if self.nao_depois.blank? 
            self.numero_serie = Carteirinha.gera_numero_serie(self.id)                    if self.numero_serie.blank?
            self.codigo_uso = Carteirinha.gera_codigo_uso                                             if self.codigo_uso.blank?
            self.qr_code = Carteirinha.gera_qr_code(Estudante.find(self.estudante_id).chave_acesso)   if self.qr_code.blank?
            self.certificado = Carteirinha.gera_certificado(self)                                     if self.certificado.blank?
        end
	end

	def self.gera_numero_serie(id)
		if last
			return last.numero_serie if last.id == id
			return last.id.to_i+1
		else
			return 1
		end
	end

	def self.gera_codigo_uso
		SecureRandom.random_number(10)
	end 

	def self.gera_certificado(carteirinha)
		# entidade = Entidade.instance
		# pub_key = entidade.authority_key_identifier
		# crl_dist_points = entidade.crl_dist_points
		# auth_info_access = entidade.authority_info_access
		# nome = entidade.nome
		# sigla = entidade.sigla
		
		# if pub_key.blank?
		# 	raise "Chave pública não definida para a entidade."	
		# end
		
		# if crl_dist_points.blank?
		# 	raise "CRL Distribution Points não definido para a Entidade"
		# end
		
		# if sigla.blank?
		# 	raise "Sigla não definida para a entidade."
		# end

		# if nome.blank?
		# 	raise "Nome não definido para a entidade."
		# end

		# if authority_info_access.blank?
		# 	raise "Authority Info Access não definido para a entidade."
		# end

		# content1 = AttributeContentOID1.new
		# content1.setDataNascimento(carteirinha.data_nascimento.to_time.to_java)
		# content1.setCpf(carteirinha.cpf)
		# content1.setMatricula(carteirinha.matricula)
		# content1.setRg(carteirinha.rg)
		# content1.setExpeditorRG(carteirinha.expedidor_rg)

		# content2 = AttributeContentOID2.new
		# content2.setCityInstEnsino(carteirinha.cidade_inst_ensino)
		# content2.setCourseName(carteirinha.curso_serie)
		# content2.setEscolarity(carteirinha.escolaridade)
		# content2.setInstEnsino(carteirinha.instituicao_ensino)
		# content2.setUfInstEnsino(carteirinha.uf_inst_ensino)

		# info = StudentACInfoGenerator.new
		# info.setHolderByParams(sigla, carteirinha.nome)
		# info.setIssuerByParams(sigla, nome)
		# info.setSerialNumber(carteirinha.numero_serie)
		# info.setNotBefore(carteirinha.nao_antes.to_time.to_java)
		# #info.addMandatoryExtensions(, auth_info_access, crl_dist_points)
		# info.addAttributes(content1, content2)

		# AttributeCertificate ca = info.generateAttributeCertificateInfo
		# ca.getEncoded()

	end

	def self.gera_qr_code chave_acesso
		entidade = Entidade.instance
		url_qr_code = entidade.url_qr_code
		if url_qr_code.blank?
			raise "url_qr_code não informada para a entidade."
		else
			return url_qr_code.concat(chave_acesso)
		end
	end

	protected
		def vencida
			self.vencimento == "1"	
		end
end