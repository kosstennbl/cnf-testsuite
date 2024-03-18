require 'yaml'

module ExternalTools
  @@kyverno = nil
  
  def kyverno
     @@kyverno ||= Kyverno.new
  end
end

World(ExternalTools)