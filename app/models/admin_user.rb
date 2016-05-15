class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # expressões regulares
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  STRING_REGEX = /\A[a-z A-Z]+\z/

  #validações
  validates :nome, length: {maximum: 70, too_long: "Máximo de %{count} caracteres permitidos!"}, 
                         format:{with: STRING_REGEX, message:"Somente letras é permitido!"}, allow_blank: true
  validates :email, uniqueness: {message: "Email já utilizado!"}, format: {with: EMAIL_REGEX , on: :create}
  validates :sexo, inclusion:{in: %w(masculino feminino), message: "%{value} não é um gênero válido."}, allow_blank: true
  validates :usuario, presence: true, length:{in: 6..10, wrong_length: "Tamanho errado %{count}"}
  validates :expedidor_rg, length:{maximum: 10, too_long:"Máximo de 10 caracteres permitidos!"}, 
               format:{with:STRING_REGEX, message: "Somente letras é permitido!"}, allow_blank: true
  validates :uf_expedidor_rg, length:{is: 2}, format:{with:STRING_REGEX}, allow_blank: true
  validates :uf, length:{is: 2}, format:{with:STRING_REGEX}, allow_blank: true
  validates :telefone, length:{in: 10..11}, numericality: true, allow_blank: true
  validates :logradouro, length:{maximum: 50}, allow_blank: true
  validates :complemento, length:{maximum: 50}, allow_blank: true
  validates :setor, length:{maximum: 50}, allow_blank: true
  validates :cep, length:{is: 8}, numericality: true, allow_blank: true
  validates :cidade, length:{maximum: 30, too_long:"Máximo de 70 carectetes é permitidos!"}, allow_blank: true
  validates :celular, length:{in: 10..11}, numericality: true, allow_blank: true
  validates :numero, length:{maximum: 5}, numericality: true, allow_blank: true
  validates :rg, numericality: true, allow_blank: true
  validates :cpf, numericality: true, length:{is: 11, too_long: "Necessário 11 caracteres.",  too_short: "Necessário 11 caracteres."}, allow_blank: true
  validates :setor, length: { maximum: 30, too_long: "Máximo de 30 caracteres permitidos!"}, allow_blank: true
  validates :super_admin, inclusion:{in: %W( 0 1), message: "%{value} não é válido super_admin"}, length: {is: 1}, allow_blank: false
  validates :status, inclusion:{in: %W( 0 1), message: "%{value} não é válido status: 1 para ativo ou 0 para inativo"}, length: {is: 1}, allow_blank: false

  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true

  def ativo?
  	self.status == "1"
  end

  def super_admin?
  	self.super_admin == "1"
  end

  private    
    def password_required?
      new_record? ? super : false
    end  

end