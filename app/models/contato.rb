class Contato 
	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

	attr_accessor :nome, :email, :assunto, :mensagem , :telefone

	validates_presence_of :nome, :email, :mensagem
	validates :nome, :length => {in: 2..50, too_short:"Máximo de 50 caracteres permitidos."}
	validates :email, :format => {:with => EMAIL_REGEX}
	validates :telefone, :length => {in: 10..11}, numericality: true
	validates :assunto, :length => {in: 2..30, too_long: "Máximo de 30 caracteres permitidos.",
									too_short: "Mínimo de 10 caracteres permitidos."}
	validates :mensagem, :length => {in: 10..750, too_long: "Máximo de 750 caracteres permitidos.",
									too_short: "Mínimo de 10 caracteres permitidos."}

	def initialize(attributes = {})
		attributes.each do |name, value|
			send("#{name}=", value)
		end
	end

	def persisted?
		false
	end
end
