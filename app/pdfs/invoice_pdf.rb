#encoding: utf-8

class InvoicePdf < Prawn::Document

  include ActionView::Helpers::NumberHelper

  def initialize(invoice, bill_id)
    super(page_size: "A4", margin: 0)
  end
end
