class AddAttachmentColumnsToCarteirinhas < ActiveRecord::Migration
  def change
    add_attachment :carteirinhas, :comprovante_matricula
    add_attachment :carteirinhas, :xerox_rg
    add_attachment :carteirinhas, :xerox_cpf
  end
end
