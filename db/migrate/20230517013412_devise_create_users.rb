
class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.uuid :id
      t.string :full_name
      t.string :email
      t.string :encrypted_password, null: false, default: ""
      t.string :roles
      t.integer :status
      t.string :provider
      t.uuid :company_id
      t.datetime :created_date
      t.datetime :modified_date
      t.datetime :deleted_date

      #Rememberable
      t.datetime :remember_created_at
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end