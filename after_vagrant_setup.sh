#　~/.ssh/configに書かれれるHOST名。
# 変更可能
ssh_config_host="vagrant"

secret_key="ansible_ecdsa"

secret_key_path=$HOME/.ssh/$secret_key

# vagrant(server)側の設定をクライアント側のPCに書く。
vagrant ssh-config  --host $ssh_config_host >> $HOME/.ssh/config

# scpは非推奨になったためrsyncで実装
# 同期先（クライアント側）に同じ名前のファイルがあった場合は上書きしない
rsync -av --ignore-existing $ssh_config_host:/home/vagrant/$secret_key $HOME/.ssh/$secret_key

# 秘密鍵をダウンロードしたので、安全のためサーバー側の秘密鍵を削除
ssh $ssh_config_host rm /home/vagrant/$secret_key

# 秘密鍵を使うためにパーミッション変更
chmod 600 $HOME/.ssh/$secret_key

# User,IdentityFileをansibleの物に変更
vagrant ssh-config  --host ${ssh_config_host}_ansible >> $HOME/.ssh/config
#     perl -ep 's/User vagrant/User ansible/' |
#     perl -eps "s/IdentityFile .*$/IdentityFile $secret_key_path/"
