# frozen_string_literal: true

class Url < ApplicationRecord
  # scope :latest, -> {}
  # scope :clicks_count, -> { url.clicks.count }

  validate :valid_url?
  validates_uniqueness_of :short_url
  validates_presence_of :short_url, :original_url
  has_many :clicks

  def valid_url?
    uri = URI.parse(original_url)
    errors.add(:original_url, 'Invalid') if uri.host.blank?
  rescue URI::InvalidURIError
    errors.add(:original_url, 'Invalid')
  end
end
