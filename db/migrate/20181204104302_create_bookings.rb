class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.integer :no_of_pax
      t.string :spec_req
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.decimal :paid
      t.decimal :discount

      t.timestamps
    end
  end
end
