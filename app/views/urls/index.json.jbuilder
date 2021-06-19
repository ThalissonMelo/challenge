json.data do
  json.array! @urls.each do |url|
    json.type "urls"
    json.id url.id
    json.attributes do
      json.created_at url.created_at
      json.original_url url.original_url
      json.url "http://127.0.0.1:3000/" + url.short_url
      json.clicks url.clicks.count
    end
    json.clicks do
      json.array! url.clicks.each do |click|
        json.data do
          json.type "click"
          json.id click.id
          json.attributes do
            json.browser click.browser
            json.platform click.platform
          end
        end
      end
    end
  end
end