class NoticiaSerializer < ActiveModel::NoticiaSerializer
	ActiveModel::Serializer.root = false

	attributes type:, :id, :title, :author, :photo, :body

	def type
		'noticia'
	end

end