class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles, id: :uuid do |t|
      t.string :name
      t.text :description
      t.timestamps
      t.datetime :deleted_at
    end
  end
end