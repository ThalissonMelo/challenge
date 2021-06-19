# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    subject(:new_url) { url.save }

    context 'when url is valid' do
      let(:url) { FactoryBot.build(:url) }

      it { expect(url.attributes).to include('original_url') }
      it { expect(url.attributes).to include('short_url') }
      it { expect(new_url).to be_truthy }
    end

    context 'when url is invalid' do
      context 'when there is no original url' do
        let(:url) { FactoryBot.build(:url, original_url: nil) }

        it { expect(new_url).to be_falsey }
      end

      context 'when there is no short url' do
        let(:url) { FactoryBot.build(:url, short_url: nil) }

        it { expect(new_url).to be_falsey }
      end

      context 'when url is invalid' do
        let(:url) { FactoryBot.build(:url, original_url: 'invalid_url') }

        it { expect(new_url).to be_falsey }
      end
    end
  end
end
