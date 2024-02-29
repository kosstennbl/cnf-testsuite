require 'yaml'

CONFIG_PATH = 'config/testcatalog-config.yml'

module ExternalTools
  @@kyverno = nil
  
  def kyverno
     @@kyverno ||= Kyverno.new
  end
end
module Config
  @@config = nil

  def config
    @@config ||= begin
      YAML.load_file(CONFIG_PATH)
    rescue Errno::ENOENT => e
      warn "Error: Configuration file not found at '#{CONFIG_PATH}'."
      raise e
    rescue Psych::SyntaxError => e
      warn "Error: Configuration file could not be loaded due to syntax errors."
      raise e
    end
 end
end

World(ExternalTools)
World(Config)