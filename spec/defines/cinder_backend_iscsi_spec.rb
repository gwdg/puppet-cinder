require 'spec_helper'

describe 'cinder::backend::iscsi' do

  let(:title) {'hippo'}

  let :req_params do {
    :iscsi_ip_address => '127.0.0.2',
    :iscsi_helper => 'tgtadm',
  }
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  let :params do
    req_params
  end

  describe 'with default params' do

    it 'should configure iscsi driver' do
      should contain_cinder_config('hippo/volume_backend_name').with(
        :value => 'hippo')
      should contain_cinder_config('hippo/volume_driver').with(
        :value => 'cinder.volume.drivers.lvm.LVMISCSIDriver')
      should contain_cinder_config('hippo/iscsi_ip_address').with(
        :value => '127.0.0.2')
      should contain_cinder_config('hippo/iscsi_helper').with(
        :value => 'tgtadm')
      should contain_cinder_config('hippo/volume_group').with(
        :value => 'cinder-volumes')
    end
  end

  describe 'iscsi backend with additional configuration' do
    before :each do
      params.merge!({:extra_options => {'hippo/param1' => {'value' => 'value1'}}})
    end

    it 'configure iscsi backend with additional configuration' do
      should contain_cinder_config('hippo/param1').with({
        :value => 'value1',
      })
    end
  end

  describe 'with RedHat' do

    let :facts do
      {:osfamily => 'RedHat'}
    end

    it { should contain_file_line('cinder include').with(
      :line => 'include /etc/cinder/volumes/*',
      :path => '/etc/tgt/targets.conf'
    ) }

  end

end
