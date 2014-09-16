class CreateTrackingNumbers < ActiveRecord::Migration
  def change
    create_table :tracking_numbers do |t|
      t.string :name
      t.string :number
      t.boolean :active, default: true
      t.string :carrier
      t.text :info
      t.integer :days_until_delivery, default: 0
      t.string :last_location

      t.timestamps
    end
  end
end
