class AddCodigoAnfitrionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :codigoAnfitrion, :integer, limit: 4
  end
end
