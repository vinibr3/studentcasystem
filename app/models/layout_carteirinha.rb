class LayoutCarteirinha < ActiveRecord::Base
	has_many :carteirinhas

	has_attached_file :verso
	has_attached_file :anverso

	# @@instance = LayoutCarteirinha.new
	# @@last_layout = LayoutCarteirinha.last

	FILES_NAME_PERMIT = [/png\Z/, /jpe?g\Z/]
	FILES_CONTENT_TYPE = ['image/jpeg', 'image/png']

	validates_attachment_size :verso, :less_than=> 2.megabytes
	validates_attachment_file_name :verso, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :verso, :content_type => FILES_CONTENT_TYPE
	validates_attachment_size :anverso, :less_than=> 2.megabytes
	validates_attachment_file_name :anverso, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :anverso, :content_type => FILES_CONTENT_TYPE

	# def self.instance
	# 	 if @@last_layout.nil? 
	# 	 	return 0	
	# 	 else
	# 	 	return @@last_layout
	# 	 end
	# end

	def self.last_layout_id
		last = LayoutCarteirinha.last
		last.nil? ? 0 : last.id
	end

	def self.anverso
		LayoutCarteirinha.last ? LayoutCarteirinha.last.anverso : nil
	end

end