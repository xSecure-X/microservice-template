class CreateUserRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_roles, id: :uuid do |t|
      t.uuid :userId
      t.uuid :roleId
      t.timestamps
      t.datetime :deleted_at

      
    end
    add_index :user_roles, [:userId, :roleId]
  end
end
