class AddAttachmentToEstudantes < ActiveRecord::Migration
  def change
    add_attachment :estudantes, :xerox_cpf
  end
end
