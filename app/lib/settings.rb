module Settings
  def self.method_missing(key, *args, &block)
    @config ||= HashWithIndifferentAccess.new(YAML.load(File.read(Rails.root.join("config", "settings.yml"))))
    env_value = ENV[key.to_s]
    yaml_value = @config[key] ? @config[key] : nil
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