require 'spec_helper'

describe 'kibana', :type => :class do
  let(:facts) { {:osfamily => 'Debian', :lsbdistcodename => 'precise'} }

  context 'no parameters' do
    it { should create_class('kibana::config')}
    it { should create_class('kibana::install')}
    it { should create_class('kibana::service')}

    it { should include_class('git')}
    it { should_not create_class('ruby')}

    it { should contain_file('/opt/kibana/KibanaConfig.rb').with_content(/KibanaPort = 5601/)}
    it { should contain_file('/opt/kibana/KibanaConfig.rb').with_content(/Elasticsearch = "localhost:9200"/)}

    it { should contain_file('/etc/init/kibana.conf')}
    it { should contain_file('/etc/init.d/kibana')}
    it { should contain_service('kibana').with_ensure('running').with_enable('true') }
  end

  context 'no managed ruby' do
    let(:params) { {'manage_ruby' => true} }

    it { should create_class('ruby')}
  end

  context 'with an invalid manage ruby instruction' do
    let(:params) { {'manage_ruby' => 'invalid'} }
    it do
      expect {
        should_not create_class('ruby')
      }.to raise_error(Puppet::Error)
    end
  end


end
