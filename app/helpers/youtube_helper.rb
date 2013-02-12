module YoutubeHelper

  def grant_access_link
    link_to t('youtube.click_here'), @grant_access_url
  end

end
