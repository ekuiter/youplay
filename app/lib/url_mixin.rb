module UrlMixin
  def play_url
    "#{Rails.application.routes.url_helpers.play_path}?#{provider}:#{url}"
  end
end