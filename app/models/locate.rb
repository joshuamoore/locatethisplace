class Locate < ActiveRecord::Base
  attr_accessible :name, :lat, :lng, :address1, :address2, :city, :state, :zip, :parent_id


end
