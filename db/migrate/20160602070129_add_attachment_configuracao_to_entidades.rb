class AddAttachmentConfiguracaoToEntidades < ActiveRecord::Migration
  def self.up
    change_table :entidades do |t|
      t.attachment :configuracao
    end
  end

  def self.down
    remove_attachment :entidades, :configuracao
  end
end
