class Player::PlayerController < ApplicationController

  include Player::VideoPlayer

  def index
    @recently_watched_videos = current_user.recently_watched_videos
  end

  def play
    begin
      fetched = fetch_video params
      if fetched
        @video = fetched[:video]
        @saved_video = current_user.videos.where(url: @video.unique_id).first
        if @saved_video.nil?
          @saved_video = current_user.videos.new browser: user_browser, channel_topic: @video.author.name,
                          title: @video.title, url: @video.unique_id, duration: @video.duration
          @saved_video.save
        end
      end
    rescue
      bad_request
    end
  end

end
