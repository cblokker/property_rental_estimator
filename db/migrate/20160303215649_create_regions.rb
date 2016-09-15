class CreateRegions < ActiveRecord::Migration
  def change
    create_table "regions" do |t|
      t.string :zipcode
      t.float  :regression_slope
      t.float  :regression_intercept
    end
  end
end
