require 'rails_helper'

RSpec.describe 'Bill', type: :model do
  subject { create(:bill) }

  describe '#sent!' do
    it 'change the bill status to sent' do
      subject.sent!

      expect(subject.status).to eq('sent')
    end
  end
end