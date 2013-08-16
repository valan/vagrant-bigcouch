#!/bin/sh

admin_user="user"
admin_pass="password"
db_dir="/vagrant/databases"
view_dir="/vagrant/views"
extra_packages="vim zip unzip"
node_name="nodename"
node_secret="nodesecret"

echo "deb http://packages.cloudant.com/ubuntu `lsb_release -cs` main" | sudo tee /etc/apt/sources.list.d/cloudant.list
sudo apt-get update -y --force-yes --allow-unauthenticated
sudo apt-get install -y --force-yes --allow-unauthenticated bigcouch curl $extra_packages

sudo echo "" > /opt/bigcouch/etc/vm.args
sudo echo "-name bigcouch@$node_name" >> /opt/bigcouch/etc/vm.args
sudo echo "-setcookie $node_secret" >> /opt/bigcouch/etc/vm.args
sudo echo "-sasl errlog_type error" >> /opt/bigcouch/etc/vm.args
sudo echo "+K true" >> /opt/bigcouch/etc/vm.args
sudo echo "+A 16" >> /opt/bigcouch/etc/vm.args
sudo echo "+Bd -noinput" >> /opt/bigcouch/etc/vm.args

sudo mkdir $db_dir
sudo mkdir $view_dir

sudo echo "[couchdb]" >> /opt/bigcouch/etc/local.ini
sudo echo "database_dir = $db_dir" >> /opt/bigcouch/etc/local.ini
sudo echo "view_index_dir = $view_dir" >> /opt/bigcouch/etc/local.ini

sleep 15

curl -X PUT "http://127.0.0.1:5984/_config/admins/$admin_user" -d "\"$admin_pass\""
