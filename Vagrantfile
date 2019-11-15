# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/bionic64'
  config.vm.box_check_update = false
  config.vm.host_name = 'microk8s.vagrantup.com'

  config.vm.network :private_network, ip: "192.168.33.33"

  config.vm.provider 'virtualbox' do |vb|
    vb.cpus = 4
    vb.memory = 4096
    vb.name = 'microk8s'
  end
  config.vm.provision 'shell', path: 'provision.sh'
end
