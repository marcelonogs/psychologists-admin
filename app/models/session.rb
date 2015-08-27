#encoding: utf-8

class Session < ActiveRecord::Base

  attr_accessible :start_date, :duration, :bill_id, :serie_id, :observations, :price

  scope :reverse, order("created_at DESC")
  scope :not_in_bill, where("bill_id IS NULL")

  belongs_to :serie
  belongs_to :bill

  before_save :round_up_price

  after_destroy :destroy_bill_if_empty

  def self.observations
    [
      "Séance individuelle",
      "Séance de couple/Famille",
      "Séance de groupe",
      "Supervision",
      "Evaluation fonct. intellectuelles",
      "Evalutation psychologique",
      "Rapport"
    ]
  end

  def self.durations
    [
      "30min-","30min", "30min+", "45min-", "45min", "45min+",
      "1h-", "1h", "1h+", "1h30-", "1h30", "1h30+"
    ]
  end

  def self.default_order
    order("start_date DESC")
  end

  def self.bill_order
    order("start_date ASC")
  end

  def report?
    observations == "Rapport"
  end

  # We need to know two things:
    # ==> Is the session in a bill?
    # ==> Is the session in the bill given in parameter?
  def in_bill?(bill_id = nil)
    bool  = bill.present?
    bool &= (bill_id == bill.id) if bill_id.present? && bill.present?
    bool
  end

  def in_draft_bill?(bill_id = nil)
    bool  = bill.present? && bill.draft?
    bool &= bill_id == bill.id if bill_id.present? && bill.present?
    bool
  end

  def in_finalized_bill?(bill_id = nil)
    bool  = bill.present? && bill.finalized?
    bool &= bill_id == bill.id if bill_id.present? && bill.present?
    bool
  end

  def deletable?
    !in_bill? || in_draft_bill?
  end

  private

      def destroy_bill_if_empty
         bill.destroy if bill.present? && bill.sessions.empty?
      end

      def round_up_price
        self.price = round_to_fraction(price, 5)
      end

      def round_to_fraction(number, fraction = 0.5)
        return 0.0 unless number
        multiplier = 1.0 / fraction
        (multiplier * number).round / multiplier
      end

end
