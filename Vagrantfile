# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/focal64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  
  # This is a project 
  config.vm.synced_folder "../", "/home/vagrant"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
      vb.memory = "4096"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL

    # デフォルトのログインユーザー,vagrantの場合はvagrant,awsなどはec2-userなど
    loginuser=vagrant

    apt-get update && apt-get -y upgrade
    # pwmakeを使うためにインストール
    apt -y install libpwquality-tools
    # ansible からwordpressや、redmineなどの構成をインストールできるように
    # ansibleユーザーを作成しておく。
    # クライアントがansibleでsshからログインできるように
    # /home/ansible/.ssh/ansible_ecdsa をクライアント側にダウンロード。
    # 秘密鍵をダウンロードしたら、vagrant(server)側の秘密鍵を削除すること。
    useradd -m ansible -s /bin/bash

    # ansibleからsudoを実行するために必要
    usermod -aG sudo ansible

    # ansibleユーザーのパスワードはansible-vault encryptで設定するので、秘密鍵のパスワードの設定はしない。
    su ansible -c 'ssh-keygen -t ecdsa -f /home/ansible/.ssh/ansible_ecdsa -N ""'
    su ansible -c 'cat /home/ansible/.ssh/ansible_ecdsa.pub >> /home/ansible/.ssh/authorized_keys'
    rm /home/ansible/.ssh/ansible_ecdsa.pub

    # デフォルトのログインユーザーで秘密鍵をダウンロード、削除できるようにファイルを移動
    mv /home/ansible/.ssh/ansible_ecdsa /home/$loginuser/
    # デフォルトのログインユーザーで秘密鍵をダウンロード、削除できるように所有者を変更
    chown $loginuser:$loginuser /home/$loginuser/ansible_ecdsa

    # ansibleがplyabookでsudoが使えるように設定
    ansible_password=$(pwmake 64)
    echo ansible:${ansible_password} | chpasswd

    echo ansible_become_pass: ${ansible_password} > /home/$loginuser/ansible_password.yml
    # vagrantユーザーでansibleのパスワードをダウンロード、削除できるようにユーザーを変更
    chown $loginuser:$loginuser /home/$loginuser/ansible_password.yml
  SHELL
end
