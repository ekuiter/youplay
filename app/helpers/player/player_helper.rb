module Player::PlayerHelper

  def player
    player_width = Constants::player_width
    player_height = Constants::player_height
    if @video.provider == :youtube
      player_skin = current_user.player_skin
      return @video.embed_html5(width: player_width, height: player_height).html_safe if player_skin == t('conf.youtube_player')
      jw_folder = Constants::jw_folder client: true
      skin_folder = Constants::skin_folder client: true
      skin_file = "#{skin_folder}/#{player_skin}.zip"
      return raw <<HTML
<div id="player"></div>
<script type="text/javascript">
  jwplayer("player").setup({
  flashplayer: "#{jw_folder}/player.swf",
  file: "#{@video.url}",
  autoplay: "false",
  controlbar: "bottom",
  width: "#{player_width}",
  height: "#{player_height}",
  plugins: "hd-2,backstroke-1",
  skin: "#{skin_file}"
});
</script>
HTML
    elsif @video.provider == :twitch
      return raw <<HTML
<div id="player"></div>
<script type="text/javascript">
  window.onPlayerLoad = function() {
    var player = $("#player")[0];
    player.unmute();
    player.loadVideo("#{@video.id}");
    player.pauseVideo();
  };
  swfobject.embedSWF("//www-cdn.jtvnw.net/swflibs/TwitchPlayer.swf", "player", "#{player_width}", "#{player_height}", "11", null,
    {"initCallback":"onPlayerLoad", "embed":1},
    {"allowScriptAccess":"always", "allowFullScreen":"true"});
</script>
HTML
    end
  end

  def description
    require 'rails_rinku'
    auto_link @video.description.gsub("\n", '<br />').html_safe, :all, target: '_blank'
  end

  def video_download_url
    "#{Constants.video_download}#{@video.provider}/#{@video.id}"
  end

end
