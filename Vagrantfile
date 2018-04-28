Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/trusty32"

    config.vm.provider "virtualbox" do |v|
        v.name = "cFE2cos_dev"
        v.memory = 2048
        v.cpus = 3

        v.customize ["modifyvm", :id, "--paravirtprovider", "kvm"]
        v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
    end

    # Disable the default syncing
    config.vm.synced_folder ".", "/vagrant", disabled: true
    # Instead sync to a more sensible location
    config.vm.synced_folder ".", "/home/vagrant/cFE2cos"

    # Forward GUI applications
    config.ssh.forward_x11 = true

    config.vm.provision "shell", path: "provision.sh"
end
