require 'yaml'
class SettingsReader
  @@settings = nil
  @@settings_file = "settings.yaml"
    
  def initialize(file_name)
      @@settings = YAML.load_file(file_name)
  end

  def self.get_setting(key)
    if @@settings == nil
      @@settings = YAML.load_file(@@settings_file)
    end
    return @@settings[key]
  end
end

