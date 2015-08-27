#encoding: utf-8

class Bill < ActiveRecord::Base

  attr_accessible :reference_number, :status, :serie_id, :contact_id, :sent_on, :paid_on, :notes, :recall_sent_on

  searchkick word_end: [:reference_number]

  has_many	 :sessions
  belongs_to :contact

  validates :reference_number, uniqueness: true

  before_validation :modify_refnum_only_if_draft
  before_validation :set_reference_number

  STATUSES = {
    draft: "draft",
    sent: "sent",
    paid: "paid",
    first_recall: "first_recall",
    second_recall: "second_recall",
    last_recall: "last_recall"
    #delegated: "delegated"
  }

  def self.default_order
    order('created_at DESC')
  end

  def sent!
    update_attribute :status, "sent"
  end

  def paid!
    update_attribute :status, "paid"
  end

  def recall!
    case status
    when STATUSES[:first_recall]
      update_attribute :status, STATUSES[:second_recall]
    when STATUSES[:second_recall]
      update_attribute :status, STATUSES[:last_recall]
    else update_attribute :status, STATUSES[:first_recall]
    end
  end

  def draft?
    status == STATUSES[:draft]
  end

  def sent?
    !draft?
  end

  def paid?
    status == STATUSES[:paid]
  end

  def recalled?
    [STATUSES[:first_recall], STATUSES[:second_recall], STATUSES[:last_recall]].include?(status)
  end

  private

    def modify_refnum_only_if_draft
      if !draft? && reference_number != reference_number_was
        errors.add(:base, "Impossible de modifier le numéro de référence si la facture a été envoyée.")
      end
    end

    def set_reference_number
      return if self.reference_number.present?
      ref_num = nil

      begin
        ref_num = "0000000005682679600000"
        ref_num += (10**3 + rand(10**4 - 10**3)).to_s
        ref_num += compute_key_number(ref_num)
      end while Bill.find_by_reference_number(ref_num).present?

      self.reference_number = ref_num
    end

    def compute_key_number(reference_number)

      # Initial data.
      report_array = [0, 9, 4, 6, 8, 2, 7, 1, 3, 5]
      reference_number_array = reference_number.split('').map(&:to_i)

      report = 0
      reference_number_array.each do |reference_digit|
        report = report_array.cshift(report)[reference_digit]
      end

      ((10 - report) % 10).to_s
    end
end
