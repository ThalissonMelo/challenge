class ThisMonthClicksQuery
  def initialize(url)
    @url = url
  end

  def by_created_at
    @url.clicks.where(created_at: 1.month.ago..Time.now).group('date(created_at)').count
  end
end