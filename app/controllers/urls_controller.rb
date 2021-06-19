# frozen_string_literal: true

class UrlsController < ApplicationController
  before_action :url, only: [:show, :visit]

  def index
    @url = Url.new
    @urls = Url.last(10)
  end

  def create
    @url = Url.new(url_params)
    @url.short_url = UrlShortenerService.new(@url.original_url).generate

    if @url.save
      redirect_to url_path(@url.short_url)
    else
      flash[:errors] = @url.errors.full_messages.first
      redirect_to root_path
    end
  end

  def show
    if @url.present?
      @daily_clicks = GraphicInformactionService.new(@url).daily_clicks
      @browsers_clicks = @url.clicks.group(:browser).count.to_a
      @platform_clicks = @url.clicks.group(:platform).count.to_a
    else
      return render :file => "#{Rails.root}/public/404.html", status: 404 if @url.blank?
    end
  end

  def visit
    return render :file => "#{Rails.root}/public/404.html", status: 404 if @url.blank?

    CreteClicksService.new(@url, request.env["HTTP_USER_AGENT"]).run
    redirect_to url.original_url
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def url
    @url = Url.find_by_short_url(params[:url])
  end
end
