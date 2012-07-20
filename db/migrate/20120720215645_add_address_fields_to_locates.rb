class AddAddressFieldsToLocates < ActiveRecord::Migration
  def change
    add_column :locates, :address1, :string
    add_column :locates, :address2, :string
    add_column :locates, :city, :string
    add_column :locates, :state, :string
    add_column :locates, :zip, :string
  end
end
