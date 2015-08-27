#encoding: utf-8

class Contact < ActiveRecord::Base

  searchkick word_start: [:firstname, :lastname]

  attr_accessible :birthdate, :city, :civil_status, :firstname, :lastname, :phone_mobile, :phone_mobile_2, :phone_perso, :phone_pro, :rate_30, :rate_45, :rate_60, :referent, :street, :title, :is_archived, :zipcode, :country, :bureau, :is_cotherapy, :rate_cotherapy, :bill_every_x_sessions, :is_bill_every_month, :language, :nationality, :treatment_state, :is_billing_contact, :billing_title, :billing_firstname, :billing_lastname, :billing_street, :billing_city, :billing_zipcode, :billing_country
  has_many :nationalities
  has_many :languages
  has_many :series
  has_many :bills

  scope :archived, where(is_archived: true)
  scope :active, where(is_archived: false)

  after_create :create_default_serie

  TITLES         = [ "Monsieur", "Madame", "Monsieur & Madame", "Votre Fils,", "Votre Fille,", "Famille" ]
  CIVIL_STATUSES = [ "Célibataire", "Couple", "Marié(e)", "Divorcé(e)", "Séparé(e)", "Partenariat enregistré" ]
  BUREAUS        = [ "geneva", "nyon" ]

  def self.default_scope
    order("lastname", "firstname")
  end

  def price_from_duration(duration)
    case duration
    when "30", "45"
      send "rate_#{duration.to_i}"
    when "1h"
      rate_60
    when "1h30"
      (rate_60 * 1.5).round(2)
    else
      nil
    end.to_s
  end

  def next
    Contact.where("id > ?", id).order("id ASC").first
  end

  def prev
    Contact.where("id < ?", id).order("id DESC").first
  end

  def archived?
    is_archived
  end

  private

  	def create_default_serie
  		series.create name: "Consultation", start_date: DateTime.now.to_date
      series.create name: "Psychothérapie", start_date: DateTime.now.to_date
  	end
end
