require 'config'

module Configuration

  def self.config_init()
    Config.setup do |config|
      config.const_name = 'Settings'
    end
    Config.load_and_set_settings("config/testcatalog-config.yml")
    Settings.reload!
  end
end