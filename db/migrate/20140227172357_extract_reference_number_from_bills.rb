#encoding: utf-8

class ExtractReferenceNumberFromBills < ActiveRecord::Migration
  def up

    pattern = /.*[rR][ée]f\.? *(?:no.?)?(\d+).*/

    Bill.all.each do |b|
      if pattern.match(b.notes).present?
        b.update_attributes(reference_number: pattern.match(b.notes)[1])
      end
    end
  end

  def down

  end
end
