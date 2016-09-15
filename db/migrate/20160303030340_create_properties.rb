class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :bedrooms
      t.integer :accomodates
      t.integer :region_id, index: true
      t.timestamps null: false
    end
  end
end