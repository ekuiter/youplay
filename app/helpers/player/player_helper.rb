module Player::PlayerHelper

  def player
    player_skin = current_user.player_skin
    player_width = Constants::player_width
    player_height = Constants::player_height
    return @video.embed_html5(width: player_width, height: player_height).html_safe if player_skin == t('conf.youtube_player')
    jw_folder = Constants::jw_folder client: true
    skin_folder = Constants::skin_folder client: true
    skin_file = "#{skin_folder}/#{player_skin}.zip"
    return raw <<HTML
<div id="player"></div>
<script type="text/javascript">
  jwplayer("player").setup({
  flashplayer: "#{jw_folder}/player.swf",
  file: "#{@video.player_url}",
  autoplay: "false",
  controlbar: "bottom",
  width: "#{player_width}",
  height: "#{player_height}",
  plugins: "hd-2,backstroke-1",
  skin: "#{skin_file}"
});
</script>
HTML
  end

  def description
    require 'rails_rinku'
    auto_link @video.description.gsub("\n", '<br />').html_safe, :all, target: '_blank'
  end

  def video_download_url(id)
    "#{Constants.url_protocol}youtube/#{id}"
  end

  def broadcast_download_url(md5)
    "#{Constants.url_protocol}broadcast/#{md5}"
  end

end
