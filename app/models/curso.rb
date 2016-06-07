class Curso < ActiveRecord::Base
	has_many :estudante
	belongs_to :escolaridade
	belongs_to :instituicao_ensino
	
	validates :nome, length: { maximum: 70, too_long: "Máximo de 70 caracteres permitidos!"}
	validates_associated :escolaridade     

	before_save :upcase_all

	def upcase_all
		self.nome.upcase
	end

end
