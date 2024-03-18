require 'config'

module Configuration

  def self.config_init()
    Config.setup do |config|
      config.const_name = 'Settings'
      config.fail_on_missing = true
    end
    Config.load_and_set_settings("config/testcatalog-config-defaults.yml")
    Config.add_source!("config/testcatalog-config-overwrites.yml")
    Settings.reload!
  end
end