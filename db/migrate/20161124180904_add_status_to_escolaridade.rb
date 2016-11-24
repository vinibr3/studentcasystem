class AddStatusToEscolaridade < ActiveRecord::Migration
  def change
    add_column :escolaridades, :status, :string, :limit => 1, :default => "1"
  end
end
