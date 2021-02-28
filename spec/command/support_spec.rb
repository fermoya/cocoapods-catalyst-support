require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Catalyst do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ support }).should.be.instance_of Command::Catalyst
      end
    end
  end
end

