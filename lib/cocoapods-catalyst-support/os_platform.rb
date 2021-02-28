module CocoapodsCatalystSupport

  class OSPlatform
    attr_reader :name
    attr_reader :sdk
    attr_reader :sdk_root
    attr_reader :filter

    def self.ios
      OSPlatform.new :ios, 'iphone*', 'iPhoneOS', 'ios'
    end

    def self.macos
      OSPlatform.new :macos, 'macosx*', 'MacOS', 'maccatalyst'
    end

    def self.watchos
      OSPlatform.new :watchos, 'watchos*', 'WatchOS', 'watchos'
    end

    def self.tvos
      OSPlatform.new :tvos, 'appletvos*', 'AppleTVOS', 'tvos'
    end

    private 
    def initialize(name, sdk, sdk_root, filter)
      @name = name
      @sdk = sdk
      @sdk_root = sdk_root
      @filter = filter
    end

  end

end