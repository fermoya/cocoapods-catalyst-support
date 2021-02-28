require 'cocoapods-catalyst-support/command_helpers'

include CocoapodsCatalystSupport

module Pod
  class Command
    class Catalyst
      class Init < Catalyst
        self.summary = 'Set up your Podfile to use `cocoapods-catalyst-support`'
        self.arguments = []

        def run
          configure_podfile
        end
      end
    end
  end
end
