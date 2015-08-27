class Nationality < ActiveRecord::Base
  attr_accessible :contact_id, :name
  belongs_to :contact
end
