class CreteClicksService

  def initialize(url, user_agent)
    @url = url
    @user_agent = user_agent
  end

  def run
    @url.clicks.push(Click.new(browser: browser.name, platform: browser.platform.name))
  end

  private

  def browser
    Browser.new(@user_agent)
  end
end