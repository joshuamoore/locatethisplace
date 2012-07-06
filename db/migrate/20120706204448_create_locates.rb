class CreateLocates < ActiveRecord::Migration
  def change
    create_table :locates do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.integer :parent_id

      t.timestamps
    end
  end
end
