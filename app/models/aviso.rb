class Aviso < ActiveRecord::Base
	validates_presence_of :aviso

	def criado_em
		self.created_at
	end

end
