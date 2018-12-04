class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :email
      t.string :tel_no
      t.string :password_digest
      t.string :password_confirmation

      t.timestamps
    end
  end
end
