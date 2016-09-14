class Carteirinha < ActiveRecord::Base
	belongs_to :estudante
	belongs_to :entidade
	belongs_to :layout_carteirinha

	url_path = "/default/:class/:id/:attachment/:style/:filename"

	has_attached_file :foto, :styles => {:original => {}}, :path => "#{url_path}"
	has_attached_file :xerox_cpf, :styles => {:original => {}}, :path => "#{url_path}"
	has_attached_file :xerox_rg, :styles => {:original => {}}, :path => "#{url_path}"
	has_attached_file :comprovante_matricula, :styles => {:original => {}}, :path => "#{url_path}"

	FILES_NAME_PERMIT = [/png\Z/, /jpe?g\Z/, /pdf\Z/]
	FILES_CONTENT_TYPE = ['image/jpeg', 'image/png', 'application/pdf']

	#@@STATUS_VERSAO_DIGITAL = ["Pagamento", "Documentação", "Download", "Baixada"]
	@@STATUS_VERSAO_IMPRESSA = ["Pagamento", "Documentação", "Aprovada","Enviada", "Entregue", "Cancelada", "Revogada"]
	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
	STRING_REGEX = /\A[a-z A-Z]+\z/
	LETRAS = /[A-Z a-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ]+/

	@@status_pagamento = ["Iniciada","Aguardando Pagamento","Em Análise","Pago","Disponível","Em disputa","Estornado","Cancelado","Devolvido","Contestado"]

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
	validates :status_versao_impressa, inclusion:{in: @@STATUS_VERSAO_IMPRESSA}
	#validates :status_versao_digital, inclusion:{in: %w(Pagamento Documentação Download Baixada)}
	#validates :valor, length:{maximum: 4}
	validates :numero_serie, numericality: true, uniqueness: true, allow_blank: true
	validates :cpf, numericality: true, length:{is: 11, too_long: "Necessário 11 caracteres.",  too_short: "Necessário 11 caracteres."}, allow_blank: true
	validates :expedidor_rg, length:{maximum: 10, too_long:"Máximo de 10 caracteres permitidos!"}, 
							 format:{with:STRING_REGEX, message: "Somente letras é permitido!"}, allow_blank: true
	validates :uf_expedidor_rg, length:{is: 2}, format:{with:STRING_REGEX}, allow_blank: true
	validates :uf_inst_ensino, length:{is: 2}, format:{with:STRING_REGEX}, allow_blank: true
	validates :escolaridade, length:{maximum: 30, too_long: "Máximo de 30 caracteres permitidos!"},
							 format:{with:LETRAS, message:"Somente letras é permitido"}, allow_blank: true
	#foto
	validates_attachment_size :foto, :less_than => 1.megabytes
	validates_attachment_file_name :foto, :matches => [/png\Z/, /jpe?g\Z/]
	validates_attachment_content_type :foto, :content_type => ['image/jpeg', 'image/png', 'application/pdf']
	#xerox_rg
	validates_attachment_size :xerox_rg, :less_than => 1.megabytes
	validates_attachment_file_name :xerox_rg, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :xerox_rg, :content_type => FILES_CONTENT_TYPE
	#xerox-cpf
	validates_attachment_size :xerox_cpf, :less_than => 1.megabytes
	validates_attachment_file_name :xerox_cpf, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :xerox_cpf, :content_type => FILES_CONTENT_TYPE
	#comprovante_matricula
	validates_attachment_size :comprovante_matricula, :less_than => 1.megabytes
	validates_attachment_file_name :comprovante_matricula, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :comprovante_matricula, :content_type => FILES_CONTENT_TYPE

	validate :so_muda_status_versao_impressa_se_pagamento_confirmado, :nao_avancar_status_se_dados_em_branco

	before_update :gera_dados_se_carteirinha_aprovada, :muda_status_carteirinha_apartir_status_pagamento

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

	def status_take_while
		index = self.status_versao_impressa_to_i+1
		@@STATUS_VERSAO_IMPRESSA.take index
	end

	def solicitacao_cancelada_ou_revogada?
		self.status_versao_impressa == @@STATUS_VERSAO_IMPRESSA[5] || self.status_versao_impressa == @@STATUS_VERSAO_IMPRESSA[6]
	end

	def so_muda_status_versao_impressa_se_pagamento_confirmado
		if status_pagamento_to_i < 3 # pagamento nao confirmado
			errors.add(:status_versao_impressa, "pagamento da CIE não foi realizado") if status_versao_impressa_to_i >= 1
		end
	end

	def nao_avancar_status_se_dados_em_branco
		if self.status_versao_impressa_to_i >= 3 # ENVIADA OU ENTREGUE
            variavel = [:nao_antes, :nao_depois, :codigo_uso, :qr_code, :certificado, 
            	        :numero_serie, :layout_carteirinha_id, :estudante_id]
            variavel.each do |v|
            	errors.add(v, "não pode ficar em branco") if self[v].blank? || self[v].nil?
            end
        end
	end

	def status_pagamento
		status = self[:status_pagamento]
		case status
			when "0" then self[:status_pagamento] = @@status_pagamento[0]
			when "1" then self[:status_pagamento] = @@status_pagamento[1]
			when "2" then self[:status_pagamento] = @@status_pagamento[2]
			when "3" then self[:status_pagamento] = @@status_pagamento[3]
			when "4" then self[:status_pagamento] = @@status_pagamento[4]
			when "5" then self[:status_pagamento] = @@status_pagamento[5]
			when "6" then self[:status_pagamento] = @@status_pagamento[6]
			when "7" then self[:status_pagamento] = @@status_pagamento[7]
			when "8" then self[:status_pagamento] = @@status_pagamento[8]	
			when "9" then self[:status_pagamento] = @@status_pagamento[9]		
		end
		self[:status_pagamento]
	end

	def status_versao_impressa_to_i
		@@STATUS_VERSAO_IMPRESSA.length.times do |i|
			if @@STATUS_VERSAO_IMPRESSA[i] == self[:status_versao_impressa]
				return i
			end
		end
	end

	def status_pagamento_to_i
		@@status_pagamento.length.times do |i|
			if @@status_pagamento[i] == self[:status_pagamento]
				return i
			end
		end
	end

	def muda_status_carteirinha_apartir_status_pagamento
		#em processamento
		self.status_versao_impressa = @@STATUS_VERSAO_IMPRESSA[0] if status_pagamento_to_i <= 2
	end

	def show_status_carteirinha_apartir_do_status_pagamento
		case self.status_pagamento_to_i
			when 0 then @@STATUS_VERSAO_IMPRESSA[0]
			when 1 then @@STATUS_VERSAO_IMPRESSA[0]
			when 2 then @@STATUS_VERSAO_IMPRESSA[0]
		else 
			@@STATUS_VERSAO_IMPRESSA.from(1)
		end
	end

	def gera_dados_se_carteirinha_aprovada
		if self.status_versao_impressa == @@STATUS_VERSAO_IMPRESSA[2] # Status é 'Aprovada'
            # Gera informações  
            self.layout_carteirinha_id = LayoutCarteirinha.last_layout_id                 if self.layout_carteirinha_id.blank?
            self.nao_antes = Time.new                                                     if self.nao_antes.blank?
            self.nao_depois = Time.new(Time.new.year+1, 3, 31).to_date                    if self.nao_depois.blank? 
            self.numero_serie = Carteirinha.gera_numero_serie(self.id)                    if self.numero_serie.blank?
            self.codigo_uso = Carteirinha.gera_codigo_uso                                 if self.codigo_uso.blank?
            self.qr_code = Carteirinha.gera_qr_code(self.estudante.chave_acesso)          if self.qr_code.blank?
            # Salva documentação do estudante para a carteirinha
            estudante = self.estudante
            self.foto = estudante.foto                                             if self.foto.blank?
            self.xerox_rg = estudante.xerox_rg                                     if self.xerox_rg.blank?
            self.xerox_cpf = estudante.xerox_cpf                                   if self.xerox_cpf.blank?
            self.comprovante_matricula = estudante.comprovante_matricula           if self.comprovante_matricula.blank?
       end
	end

	def to_blob
		lyt = self.layout_carteirinha
		img = Magick::Image.read(lyt.anverso.url)
		img = img.first

		# Desenha os dados (texto) no layout
		draw = Magick::Draw.new
		draw.annotate(img, 0, 0, lyt.nome_posx, lyt.nome_posy, self.nome.upcase)                                            	 unless lyt.nome_posx.blank? && lyt.nome_posy.blank? 
		draw.annotate(img, 0, 0, lyt.instituicao_ensino_posx, lyt.instituicao_ensino_posy, self.instituicao_ensino.upcase)       unless lyt.instituicao_ensino_posx.blank? && lyt.instituicao_ensino_posy.blank? 
		draw.annotate(img, 0, 0, lyt.escolaridade_posx, lyt.escolaridade_posy, self.escolaridade.upcase)               	         unless lyt.escolaridade_posx.blank? && lyt.escolaridade_posy.blank? 
		draw.annotate(img, 0, 0, lyt.curso_posx, lyt.curso_posy, self.curso_serie.upcase)                                        unless lyt.curso_posx.blank? && lyt.curso_posy.blank? 
		draw.annotate(img, 0, 0, lyt.data_nascimento_posx, lyt.data_nascimento_posy, self.data_nascimento.strftime("%d/%m/%Y"))  unless lyt.data_nascimento_posx.blank? && lyt.data_nascimento_posy.blank? 
		draw.annotate(img, 0, 0, lyt.rg_posx, lyt.rg_posy, self.rg)                                                  		 	 unless lyt.rg_posx.blank? && lyt.rg_posy.blank? 
		draw.annotate(img, 0, 0, lyt.cpf_posx, lyt.cpf_posy, self.cpf)                                                           unless lyt.cpf_posx.blank? && lyt.cpf_posy.blank? 
		draw.annotate(img, 0, 0, lyt.nao_depois_posx, lyt.nao_depois_posy, self.nao_depois.strftime("%d/%m/%Y"))                 unless lyt.nao_depois_posx.blank? && lyt.nao_depois_posy.blank?
		draw.font_weight(700)  # bold                                             			                                             
		draw.annotate(img, 0, 0, lyt.codigo_uso_posx, lyt.codigo_uso_posy, self.codigo_uso.upcase)                         		 unless lyt.codigo_uso_posx.blank? && lyt.codigo_uso_posy.blank? 
		 
		# Desenha foto 
		foto = Magick::Image.read(self.foto.url)
		draw.composite(lyt.foto_posx, lyt.foto_posy, lyt.foto_width, lyt.foto_height, foto[0])    unless data_foto_blank(lyt)
		
		# Cria e Desenha Qr Code
		dir_qr_code = "tmp/#{self.numero_serie}.png"
		qr = RQRCode::QRCode.new( self.qr_code, :size => 6, :level => :h ).to_img 
		qr.resize(lyt.qr_code_width, lyt.qr_code_height).save(dir_qr_code)
		
		qr_code = Magick::Image.read(dir_qr_code)
		draw.composite(lyt.qr_code_posx, lyt.qr_code_posy, lyt.qr_code_width, lyt.qr_code_height, qr_code[0])    unless data_qr_code_blank(lyt)
		draw.draw(img)
		File.delete(dir_qr_code)

		img.to_blob
	end

	def self.zipfile_by_scope carteirinhas
		begin
			# Cria nome do arquivo zip
	        zipfile_name = "carteirinhas.zip"
	        path_zip = "tmp/#{zipfile_name}"

	        # Inicia o arquivo temporario como zip
	       data = Zip::OutputStream.write_buffer do |stream| 
	        	carteirinhas.each do |carteirinha|
		         	begin
		         	file_name = "#{carteirinha.numero_serie}.jpg"
		         	temp = Tempfile.new file_name
		         	img = Magick::Image.from_blob carteirinha.to_blob
		         	img.first.write temp.path #converte para jpg
		         	img = Magick::Image.read temp.path
		         	stream.put_next_entry file_name
		         	stream.write img.first.to_blob
		         	ensure
		         		temp.close
		         		temp.unlink
		         	end
		        end
	        end	 
	       {:stream=>data.string, :filename => zipfile_name}
		ensure
			#File.delete zip
			#File.delete "tmp/arquivo.zip"
		end
	end

	def self.gera_numero_serie(id)
		last = where(status_versao_impressa: @@STATUS_VERSAO_IMPRESSA[2]).last
		if last
			return last.numero_serie if last.id == id
			return last.id.to_i+1
		else
			return 1
		end
	end

	def self.gera_codigo_uso
		SecureRandom.hex(4).upcase
	end 

	def self.gera_qr_code chave_acesso
		entidade = Entidade.instance
		url_qr_code = entidade.url_qr_code
		if url_qr_code.blank? || url_qr_code.nil?
			raise "url_qr_code não informada para a entidade."
		else
			url_qr_code.end_with?("/") ? url_qr_code.concat(chave_acesso) : url_qr_code.concat("/#{chave_acesso}")
			url_qr_code
		end
	end

	def self.status_versao_impressa
		@@STATUS_VERSAO_IMPRESSA
	end

	protected
		def vencida
			self.vencimento == "1"	
		end

		def data_foto_blank layout
			layout.foto_posx.blank? && layout.foto_posy.blank? && layout.foto_width.blank? && layout.foto_height.blank?
		end

		def data_qr_code_blank layout
			layout.qr_code_posx.blank? && layout.qr_code_posy.blank? && layout.qr_code_width.blank? && layout.qr_code_height.blank?
		end

		def transacao_cancelada
			@@status_pagamento
		end
end