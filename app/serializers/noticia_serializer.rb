class NoticiaSerializer < ActiveModel::Serializer
	ActiveModel::Serializer.root = false

	attributes :type, :id, :titulo, :autor, :foto_url, :body

	def type
		'noticia'
	end

	def foto_url
		object.foto.url
	end

end