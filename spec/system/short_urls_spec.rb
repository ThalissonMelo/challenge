# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # If using Firefox
    # driven_by :selenium, using: :firefox
    #
    # If running on a virtual machine or similar that does not have a UI, use
    # a headless driver
    # driven_by :selenium, using: :headless_chrome
    # driven_by :selenium, using: :headless_firefox
  end

  describe 'index' do
    it 'shows a list of short urls' do
      10.times do |index|
        Url.create(original_url: 'http://www.google.com', short_url: 'ABCD' + index.to_s)
      end

      visit root_path
      expect(page).to have_text('HeyURL!')
      expect(page).to have_selector('tr', count: 11)
    end
  end

  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      Url.create(original_url: 'http://www.google.com', short_url: 'ABCDE')
      visit url_path('ABCDE')
      expect(page).to have_text("total clicks")
      expect(page).to have_text("Platform")
      expect(page).to have_text("Browser")
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit url_path('NOTFOUND')
        expect(page).to have_text("The page you were looking for doesn't exist.")
      end
    end
  end

  describe 'create' do
    context 'when url is valid' do
      it 'creates the short url' do
        visit root_path
        fill_in "url_original_url", with: "https://www.test.com/test/test/test"
        click_button 'Shorten URL'
        expect(page).to have_current_path(/\/urls\/[A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9][A-Z0-9]/)
        expect(page).to have_text("https://www.test.com/test/test/test")
      end
    end

    context 'when url is invalid' do
      it 'does not create the short url and shows a message' do
        visit root_path
        fill_in "url_original_url", with: "invalid url"
        click_button 'Shorten URL'
        expect(page).to have_text("url Invalid")
      end
    end
  end

  describe 'visit' do
    it 'redirects the user to the original url' do
      Url.create(original_url: 'http://www.google.com', short_url: 'ABCDE')

      visit visit_path('ABCDE')
      expect(URI.parse(current_url).hostname).to eq("www.google.com")
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')
        expect(page).to have_text("The page you were looking for doesn't exist.")
      end
    end
  end

  describe 'complete flow' do
    it 'when user creates a link someone clicks and the metrics are shown' do
      Url.create(original_url: 'http://www.google.com', short_url: 'ABCDE')

      visit visit_path('ABCDE')
      expect(URI.parse(current_url).hostname).to eq("www.google.com")

      visit root_path
      expect(page).to have_selector('#clicks', text: '1')

      visit url_path('ABCDE')
      expect(page).to have_text('100%', count: 2)
      expect(page).to have_text(1.0)
    end
  end
end
