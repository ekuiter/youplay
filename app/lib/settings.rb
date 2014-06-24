module Settings
  def self.method_missing(key, *args, &block)
    path = Rails.root.join("config", "settings.yml")
    if File.exist?(path)
      @config ||= HashWithIndifferentAccess.new(YAML.load(File.read(path)))
      yaml_value = @config[key] ? @config[key] : nil
    end
    env_value = ENV[key.to_s]
    env_value or yaml_value
  end

  def self.jw_folder hash = {} # jw player folder
    folder = 'jwplayer'
    hash[:client] ? "/#{folder}" : "public/#{folder}"
  end

  def self.skin_folder hash = {} # jw skin folder
    "#{jw_folder(hash)}/skins"
  end
end