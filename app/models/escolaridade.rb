class Escolaridade < ActiveRecord::Base
	has_many :cursos

	before_save :upcase_all

	validates :nome, length: { maximum: 30, too_long: "Máximo de 70 caracteres permitidos!"}

	def upcase_all
		self[:nome].upcase
	end

end
