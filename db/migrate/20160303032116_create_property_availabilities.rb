class CreatePropertyAvailabilities < ActiveRecord::Migration
  def change
    create_table :property_availabilities do |t|
      t.date :date
      t.integer :price
      t.string :status
      t.integer :property_id, index: true

      t.timestamps null: false
    end
  end
end
