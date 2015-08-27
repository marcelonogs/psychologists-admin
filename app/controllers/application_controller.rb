class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!

  helper_method :display_date_or_string

  def display_date_or_string(date_or_string)

    returnVal = ""

    begin
      returnVal = I18n.l Date.strptime(date_or_string, "%d.%m.%Y")
    rescue
      returnVal = date_or_string
    end

    returnVal
  end

  def change_session_organization_strategy_for(contact_id)

    contact = Contact.find(contact_id)

    # We only do from monthly to nb_sessions here.
    return if contact.is_bill_every_month

    series_id = contact.series.map(&:id)

    # All the free sessions for the current contact
    x_free_sessions    = Session.default_order.where(serie_id: series_id).not_in_bill.limit(contact.bill_every_x_sessions).order('created_at ASC')

    while x_free_sessions.present? && x_free_sessions.count == contact.bill_every_x_sessions
      bill = Bill.create(contact_id: contact.id)
      x_free_sessions.each { |s| s.update_attribute :bill_id, bill.id }
      x_free_sessions = Session.default_order.where(serie_id: series_id).not_in_bill.limit(contact.bill_every_x_sessions).order('created_at ASC')
    end
  end

end
