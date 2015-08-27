class Worker < ActiveRecord::Base
  def self.change_session_organization_strategy
    Contact.all.each do |contact|
      # We only do for monthly sessions here.
      return unless contact.is_bill_every_month

      series_id = contact.series.map(&:id)

      # All the free sessions for the current contact
      x_free_sessions    = Session.where(serie_id: series_id).not_in_bill.limit(12).order('created_at ASC')

      while x_free_sessions.present?
        bill = Bill.create(contact_id: contact.id)
        x_free_sessions.each { |s| s.update_attribute :bill_id, bill.id }
        x_free_sessions = Session.where(serie_id: series_id).not_in_bill.limit(12).order('created_at ASC')
      end
    end
  end
end