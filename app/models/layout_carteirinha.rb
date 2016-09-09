class LayoutCarteirinha < ActiveRecord::Base
	has_many :carteirinhas

	url_path = "/admin/:class/:id/:attachment/:style/:filename"

	has_attached_file :verso, :styles => {:original => {}}, :path => "#{url_path}"
	has_attached_file :anverso, :styles => {:original => {}}, :path => "#{url_path}"

	FILES_NAME_PERMIT = [/png\Z/, /jpe?g\Z/]
	FILES_CONTENT_TYPE = ['image/jpeg', 'image/png']

	validates_attachment_size :verso, :less_than=> 2.megabytes
	validates_attachment_file_name :verso, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :verso, :content_type => FILES_CONTENT_TYPE
	validates_attachment_size :anverso, :less_than=> 2.megabytes
	validates_attachment_file_name :anverso, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :anverso, :content_type => FILES_CONTENT_TYPE

	validates_numericality_of :nome_posx, :nome_posy, :instituicao_ensino_posx, :instituicao_ensino_posy,
	                          :escolaridade_posx, :escolaridade_posy, :curso_posx, :curso_posy,
	                          :data_nascimento_posx, :data_nascimento_posy, :rg_posx, :rg_posy, 
	                          :cpf_posx, :cpf_posy, :codigo_uso_posx, :codigo_uso_posy, 
	                          :nao_depois_posx, :nao_depois_posy, :qr_code_posx, :qr_code_posy, allow_blank: true

	def self.instance
		last
	end

	def self.last_layout_id
		last = self.instance
		last.nil? ? 0 : last.id
	end

	def self.anverso
		last = self.instance
		last ? last.anverso : nil
	end

end