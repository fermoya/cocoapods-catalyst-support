require 'colored2'
require 'cocoapods-catalyst-support/command_helpers'

include CocoapodsCatalystSupport

module Pod
  class Command
    class Catalyst

      class Validate < Catalyst

        self.summary = 'Validate your catalyst configuration.'

        self.description = <<-DESC
          Verify that the catalyst configuration you've given in your Podfile is valid and follows the guidelines. 
          Note that this doesn't verify your configuration is correct but it's valid.
        DESC

        self.arguments = []

        def run
          begin 
            validate_podfile
          rescue ValidationError => e
            puts e.message
          else
            puts "Congratulations! Your catalyst configuration is valid.".green
          end
        end

      end

    end
  end
end
