class InstituicaoEnsino < ActiveRecord::Base
  belongs_to :cidade
  belongs_to :estado
  belongs_to :entidade
  has_many :estudantes
  has_many :cursos

  STRING_REGEX = /\A[a-z A-Z]+\z/
  LETRAS = /[A-Z a-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ ]+/

  validates_associated :cidade, :estado, :entidade

  validates :nome, length: { maximum: 70, too_long: "Máximo de 70 caracteres permitidos!"}, 
	                 		   format:{with: LETRAS, message:"Somente letras é permitido!"},
	                 		   allow_blank: true
  validates :sigla, length: {maximum: 10, too_long: "Máximo de #{count} caracteres permitidos."},
					  format: {with: STRING_REGEX, message: "Somente letras é permitido"}
  validates :cnpj, numericality: true, length: {is: 14, wrong_length: "14 caracteres."}					  
  validates :logradouro, length:{maximum: 50}, allow_blank: true
  validates :complemento, length:{maximum: 50}, allow_blank: true
  validates :numero, length:{maximum: 5}, numericality: true, allow_blank: true
  validates :cep, length:{is: 8, wrong_length: "#{count} caracteres."}, numericality: true, allow_blank: true

  def self.cursos
    self.instituicao_ensino_cursos.cursos
  end

  def self.escolaridades
    cursos.escolaridades
  end

end

