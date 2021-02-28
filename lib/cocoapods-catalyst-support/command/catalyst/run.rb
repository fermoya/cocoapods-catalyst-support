module Pod
  class Command
    class Catalyst
      class Run < Catalyst
        self.summary = 'Configure your catalyst dependencies.'
        self.arguments = []
        def run
          system 'pod install'
        end
      end
    end
  end
end
