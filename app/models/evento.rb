class Evento < ActiveRecord::Base
	
	url_path = "/admin/:class/:id/:attachment/:style/:filename"

	has_attached_file :folder, :path => "#{url_path}"			  
					  
	FILES_NAME_PERMIT = [/png\Z/, /jpe?g\Z/]
	FILES_CONTENT_TYPE = ['image/jpeg', 'image/png']

	validates_presence_of :titulo, :data

	validates_attachment_size :folder, :less_than => 1.megabytes
	validates_attachment_file_name :folder, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :folder, :content_type => FILES_CONTENT_TYPE

	def criado_em
		self.created_at
	end

	def folder_nome
		self.folder_file_name
	end

end
