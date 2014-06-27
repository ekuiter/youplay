module UserMixins
  module Conf
    def max_recently_watched # get max number of recently watched videos
      default = 10
      max_recently_watched = configurations.find_by_feature 'max_recently_watched'
      return default if max_recently_watched.nil?
      max_recently_watched.value.to_i
    end

    def max_recently_watched=(max_recently_watched) # set max number of recently watched videos
      within = 0..100
      max_recently_watched = Integer(max_recently_watched)
      raise ArgumentError, "not within #{within.begin} and #{within.end}" unless within.include? max_recently_watched
      conf = configurations.find_by_feature 'max_recently_watched'
      conf = configurations.new if conf.nil?
      conf.feature = 'max_recently_watched'
      conf.value = max_recently_watched.to_s
      conf.save
    end

    def player_skin # get current jw player skin
      default = 'five'
      player_skin = configurations.find_by_feature 'player_skin'
      player_skin = default if player_skin.nil?
      player_skin = player_skin.value if player_skin != default
      if player_skin == I18n.t('conf.youtube_player') || FileTest.exist?("#{Settings.skin_folder}/#{player_skin}.zip")
        player_skin
      else
        false
      end
    end

    def player_skins
      skins = []
      current_skin = player_skin
      skins << current_skin
      youtube_player = I18n.t('conf.youtube_player')
      skins << youtube_player if youtube_player != current_skin
      files = Dir.open(Settings.skin_folder).entries
      files.each do |file|
        extension = File.extname file
        name = File.basename file, extension
        skins << name if extension == '.zip' && name != current_skin
      end
      skins
    end

    def player_skin=(player_skin) # set current jw player skin
      raise ArgumentError, 'skin doesn\'t exist' unless player_skin == I18n.t('conf.youtube_player') ||
          FileTest.exist?("#{Settings.skin_folder}/#{player_skin}.zip")
      conf = configurations.find_by_feature 'player_skin'
      conf = configurations.new if conf.nil?
      conf.feature = 'player_skin'
      conf.value = player_skin
      conf.save
    end
  end
end