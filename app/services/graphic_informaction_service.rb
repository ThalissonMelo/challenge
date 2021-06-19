class GraphicInformactionService
  def initialize(url)
    @url = url
  end

  def daily_clicks
    clicks = ThisMonthClicksQuery.new(@url).by_created_at

    (Time.now.at_beginning_of_month.to_date..Time.now).to_a.map do |date|
      ["#{date.month}/#{date.day}", clicks[date] || 0 ]
    end
  end
end