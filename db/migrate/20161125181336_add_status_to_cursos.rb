class AddStatusToCursos < ActiveRecord::Migration
  def change
    add_column :cursos, :status, :string, :limit => 1, :default => "1"
  end
end
