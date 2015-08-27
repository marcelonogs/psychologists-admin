class PagesController < ApplicationController

  layout false, except: :search_reference

  def refnum
    @bills = Bill.where(reference_number: nil)
  end

  def qualifications

  end

  def contact

  end

  def search_reference
    @bills = Bill.search params[:filter], fields: [{reference_number: :word_end}],
      partial: true, page: params[:page], per_page: 100
  end
end
