class UrlShortenerService

  def initialize(url)
    @url = url
  end

  def generate
    SecureRandom.uuid[0..4].upcase
  end
end