class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :address
      t.string :postal_code
      t.string :state
      t.date :date
      t.string :start_hr
      t.string :start_min
      t.string :end_hr
      t.string :end_min
      t.integer :max_pax
      t.decimal :price_per_pax
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
