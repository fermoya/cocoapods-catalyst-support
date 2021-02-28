require 'cocoapods-catalyst-support/catalyst_configuration.rb'

module Pod
  class Podfile
    module DSL
      def catalyst_configuration &block
        $catalyst_configuration.instance_eval &block
      end

      def debug!
        $verbose = true
      end
    end
  end
end