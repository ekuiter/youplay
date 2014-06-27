module PlayerHelper
  def play(video)
    player_width = Settings.player_width
    player_height = Settings.player_height
    jw_folder = Settings.jw_folder client: true
    skin_folder = Settings.skin_folder client: true
    player_skin = current_user.player_skin
    skin_file = "#{skin_folder}/#{player_skin}.zip"
    partial = video.provider.player_partial(player_skin)
    render "player/player/providers/#{partial}", video: video, player_width: player_width, 
           player_height: player_height, jw_folder: jw_folder, skin_file: skin_file
  end
end
