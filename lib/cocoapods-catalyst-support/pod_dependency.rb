module CocoapodsCatalystSupport

  class PodDependency
    attr_reader :name
    attr_reader :type
  
    def link
      case type
      when :weak_framework
        return "-weak_framework \"#{name}\""
      when :library
        return "-l\"#{name}\""
      else
        return "-framework \"#{name}\"" 
      end
    end
  
    def self.newWeakFramework name
      return PodDependency.new(name, :weak_framework)
    end
  
    def self.newFramework name
      return PodDependency.new(name, :framework)
    end
  
    def self.newLibrary name
      return PodDependency.new(name, :library)
    end
  
    def ==(other)
      (name == other.name) && (type == other.type)
    end
  
    def eql?(other)
      self == other
    end
  
    private
    def initialize(name, type)
      @name = name
      @type = type
    end
  
  end

end