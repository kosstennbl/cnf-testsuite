require 'securerandom'

module Singletons
  def namespace
    @@namespace ||= SecureRandom.uuid
  end
end

World(Singletons)