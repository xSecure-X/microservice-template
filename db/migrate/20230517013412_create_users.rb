class CreateUsers < ActiveRecord::Migration[7.0]
  def up
    create_table :users, id: :uuid do |t|
      t.string :full_name
      t.string :email
      t.string :roles
      t.integer :status
      t.uuid :company_id
      t.datetime :created_date
      t.datetime :modified_date
      t.datetime :deleted_date

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
