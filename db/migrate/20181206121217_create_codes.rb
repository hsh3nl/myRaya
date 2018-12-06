class CreateCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :codes do |t|
      t.string :key
      t.integer :role

      t.timestamps
    end
  end
end
