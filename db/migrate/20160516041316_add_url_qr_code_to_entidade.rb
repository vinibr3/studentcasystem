class AddUrlQrCodeToEntidade < ActiveRecord::Migration
  def change
    add_column :entidades, :url_qr_code, :string
  end
end
