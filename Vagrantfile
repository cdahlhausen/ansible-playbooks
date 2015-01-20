# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.ssh.forward_agent = true

  # You may have to crank down the number of CPUs if
  # you're not running on a hyperthreaded quad core.
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 8
  end
end
