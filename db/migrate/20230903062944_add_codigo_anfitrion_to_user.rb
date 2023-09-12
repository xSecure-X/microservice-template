class AddCodigoAnfitrionToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :code, :integer, limit: 4
  end
end
