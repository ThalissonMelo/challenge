# frozen_string_literal: true

FactoryBot.define do
  factory :click do
    url { build(:url) }
    browser { 'Chrome' }
    platform { 'Ubuntu' }
  end
end
