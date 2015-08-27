class Serie < ActiveRecord::Base
  attr_accessible :contact_id, :start_date, :name

  belongs_to 	:contact
  has_many		:sessions

  def self.default_order
    order('start_date DESC')
  end
end
