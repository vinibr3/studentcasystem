class AddAttachmentConfiguracaoToEntidades < ActiveRecord::Migration
  def self.up
    change_table :entidades do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :entidades, :logo
  end
end
