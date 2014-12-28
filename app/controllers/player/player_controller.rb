class Player::PlayerController < ApplicationController
  include ControllerMixins::PlayerController

  def index
    @recently_watched_videos = current_user.recently_watched_videos
    @favorited_video_ids = current_user.favorites.map {|f| f.video_id}
  end

  def play
    block = Proc.new {|o| [o.name, o.id] }
    @people = current_user.people.map(&block)
    @categories = current_user.categories.map(&block)
    return @video = play_video(params) if Rails.env.development?
    begin
      @video = play_video params
    rescue
      flash[:alert] = t('player.wrong_url')
      redirect_to player_path
    end
  end
end
