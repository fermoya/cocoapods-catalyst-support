require_relative 'utils' 

module CocoapodsCatalystSupport

  class CatalystConfiguration

    attr_reader :ios_dependencies
    attr_reader :mac_dependencies

    def initialize
      @ios_dependencies = Set.new
      @mac_dependencies = Set.new
    end
  
    def ios name
      mac_dependencies.delete name
      ios_dependencies << name
    end
  
    def macos name
      ios_dependencies.delete name
      mac_dependencies << name
    end

    def verbose!
      $verbose = true
    end
  
  end

end

module Pod 
  $catalyst_configuration = CocoapodsCatalystSupport::CatalystConfiguration.new
end