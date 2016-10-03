#!/bin/bash

yum install -y git httpd
service httpd start

# create chef cache structure
mkdir -p /var/chef/cache/cookbooks

# install chef-client
cd /var/chef
wget https://packages.chef.io/stable/el/7/chef-12.14.89-1.el7.x86_64.rpm
rpm -i chef-12.14.89-1.el7.x86_64.rpm

# run chef-zero
cd /var/chef/cache
git clone .. cookbooks/game_service
chef-client -z -o "game_service::default"
