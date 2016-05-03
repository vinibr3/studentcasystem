class LayoutCarteirinha < ActiveRecord::Base
	has_many :carteirinhas

	@@last_layout = LayoutCarteirinha.last
	@@instance = LayoutCarteirinha.new

	has_attached_file :verso
	has_attached_file :anverso

	FILES_NAME_PERMIT = [/png\Z/, /jpe?g\Z/]
	FILES_CONTENT_TYPE = ['image/jpeg', 'image/png']

	validates_attachment_size :verso, :less_than=> 2.megabytes
	validates_attachment_file_name :verso, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :verso, :content_type => FILES_CONTENT_TYPE
	validates_attachment_size :anversi, :less_than=> 2.megabytes
	validates_attachment_file_name :anverso, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :anverso, :content_type => FILES_CONTENT_TYPE

	def self.instance
		 if @@last_layout.nil? 
		 	return @@instance	
		 else
		 	@@last_layout
		 end
	end

	# def layout
	# 	if self[:layout].nil?
	# 		return "nenhum-layout-definido.png"
	# 	else
	# 		return self[:layout]
	# 	end
	# end

end
