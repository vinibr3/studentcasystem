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
            self.codigo_uso = Carteirinha.gera_codigo_uso                                 if self.codigo_uso.blank?
            self.qr_code = Carteirinha.gera_qr_code(Estudante.find(self.codigo_uso))      if self.qr_code.blank?
            #self.certificado = Carteirinha.gera_certificado(self)                         if self.certificado.blank?
        end
	end

	def to_blob
		lyt = self.layout_carteirinha
		img = Magick::Image.read(lyt.anverso.path)
		img = img.first

		# Desenha os dados (texto) no layout
		draw = Magick::Draw.new
		draw.annotate(img, 0, 0, lyt.nome_posx, lyt.nome_posy, self.nome.upcase)                                            	 unless lyt.nome_posx.blank? && lyt.nome_posy.blank? 
		draw.annotate(img, 0, 0, lyt.instituicao_ensino_posx, lyt.instituicao_ensino_posy, self.instituicao_ensino.upcase)       unless lyt.instituicao_ensino_posx.blank? && lyt.instituicao_ensino_posy.blank? 
		draw.annotate(img, 0, 0, lyt.escolaridade_posx, lyt.escolaridade_posy, self.escolaridade.nome.upcase)               	 unless lyt.escolaridade_posx.blank? && lyt.escolaridade_posy.blank? 
		draw.annotate(img, 0, 0, lyt.curso_posx, lyt.curso_posy, self.curso_serie.upcase)                                        unless lyt.curso_posx.blank? && lyt.curso_posy.blank? 
		draw.annotate(img, 0, 0, lyt.data_nascimento_posx, lyt.data_nascimento_posy, self.data_nascimento.strftime("%d/%m/%Y"))  unless lyt.data_nascimento_posx.blank? && lyt.data_nascimento_posy.blank? 
		draw.annotate(img, 0, 0, lyt.rg_posx, lyt.rg_posy, self.rg)                                                  		 	 unless lyt.rg_posx.blank? && lyt.rg_posy.blank? 
		draw.annotate(img, 0, 0, lyt.cpf_posx, lyt.cpf_posy, self.cpf)                                                           unless lyt.cpf_posx.blank? && lyt.cpf_posy.blank? 
		draw.annotate(img, 0, 0, lyt.nao_depois_posx, lyt.nao_depois_posy, self.nao_depois)                          			 unless lyt.nao_depois_posx.blank? && lyt.nao_depois_posy.blank?
		draw.font_weight(700)  # bold                                             			                                             
		draw.annotate(img, 0, 0, lyt.codigo_uso_posx, lyt.codigo_uso_posy, self.codigo_uso.upcase)                         		 unless lyt.codigo_uso_posx.blank? && lyt.codigo_uso_posy.blank? 
		 
		# Desenha foto 
		foto = Magick::Image.read(self.foto.path)
		draw.composite(lyt.foto_posx, lyt.foto_posy, lyt.foto_width, lyt.foto_height, foto[0])    unless data_foto_blank(lyt)
		
		# Cria e Desenha Qr Code
		dir_qr_code = "tmp/#{self.numero_serie}.png"
		qr = RQRCode::QRCode.new( self.qr_code, :size => 4, :level => :h ).to_img 
		qr.resize(lyt.qr_code_width, lyt.qr_code_height).save(dir_qr_code)
		
		qr_code = Magick::Image.read(dir_qr_code)
		draw.composite(lyt.qr_code_posx, lyt.qr_code_posy, lyt.qr_code_width, lyt.qr_code_height, qr_code[0])    unless data_qr_code_blank(lyt)
		draw.draw(img)
		File.delete(dir_qr_code)

		img.to_blob
	end

	def self.zipfile_by_scope scope
		begin
			carteirinhas = where(scope)

			# Cria nome do arquivo zip
	        first_numero_serie = carteirinhas.first.numero_serie
	        last_numero_serie = carteirinhas.last.numero_serie
	        zipfile_name = first_numero_serie
	        zipfile_name = zipfile_name.concat("-#{last_numero_serie}") unless carteirinhas.count <= 1
	        zipfile_name = zipfile_name.concat(".zip")
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
		last = where(status_versao_impressa: "Aprovada").last
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

	def self.gera_qr_code codigo_uso
		entidade = Entidade.instance
		url_qr_code = entidade.url_qr_code
		if url_qr_code.blank?
			raise "url_qr_code não informada para a entidade."
		else
			index = url_qr_code.rindex("/")+1
			index == url_qr_code.size ? url_qr_code.concat(codigo_uso) : url_qr_code.concat("/".concat(codigo_uso))
			return url_qr_code
		end
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
end