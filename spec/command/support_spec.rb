require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Support do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ support }).should.be.instance_of Command::Support
      end
    end
  end
end

