# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    subject(:new_click) { click.save }

    context 'when click is valid' do
      let(:click) { FactoryBot.build(:click) }

      it { expect(click.attributes).to include('url_id') }
      it { expect(click.attributes).to include('browser') }
      it { expect(click.attributes).to include('platform') }
      it { expect(new_click).to be_truthy }
    end

    context 'when click is invalid' do
      context 'when click does not have url' do
        let(:click) { FactoryBot.build(:click, browser: nil) }

        it { expect(new_click).to be_falsey }
      end

      context 'when click does not have platform' do
        let(:click) { FactoryBot.build(:click, platform: nil) }

        it { expect(new_click).to be_falsey }
      end

      context 'when click does not have url' do
        let(:click) { FactoryBot.build(:click, url: nil) }

        it { expect(new_click).to be_falsey }
      end
    end
  end
end
