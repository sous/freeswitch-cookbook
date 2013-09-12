#
# Cookbook Name:: freeswitch
# Recipe:: default
#
# Copyright (C) 2013 Sous
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'git'

directory "/opt/debs"

git '/opt/debs/freeswitch-precise' do
  repository "https://github.com/sous/freeswitch-precise.git"
  reference 'master'
  action :sync
end

execute 'apt-key add /opt/debs/freeswitch-precise/gpg-pub.gpg' do
  command 'cat /opt/debs/freeswitch-precise/gpg_pub.gpg | apt-key add -'
end

include_recipe 'apt'

apt_repository 'freeswitch-precise' do
  uri 'file:///opt/debs/freeswitch-precise'
  distribution node['lsb']['codename']
  components ["main"]
  action :add
end

package 'freeswitch-meta-vanilla'
package 'freeswitch-music'
package 'freeswitch-conf-vanilla'
package 'freeswitch-sysvinit'
package 'freeswitch-sounds-en-us-callie'

bash "initial /etc/freeswitch" do
  code 'cp -a /usr/share/freeswitch/conf/vanilla/ /etc/freeswitch'
  not_if { File.exists?( "/etc/freeswitch" ) }
end

group 'daemon'

user "freeswitch" do
  comment 'FreeSwitch'
  group 'daemon'
  system true
  home '/usr/share/freeswitch'
  shell "/bin/false"
#  supports :manage_home => true
end

directory '/etc/freeswitch' do
  mode 0755
  owner 'freeswitch'
  group 'daemon'
end

execute "fixup /etc/freeswitch owner" do
  command "chown -Rf freeswitch:daemon /etc/freeswitch"
end

directory '/usr/share/freeswitch/' do
  mode 0755
  owner 'freeswitch'
  group 'daemon'
end

execute "fixup /usr/share/freeswitch owner" do
  command "chown -Rf freeswitch:daemon /usr/share/freeswitch"
end

link '/usr/share/freeswitch/sounds/music/8000' do
  to '/usr/share/freeswitch/sounds/music/default/8000'
end

link '/usr/share/freeswitch/sounds/music/16000' do
  to '/usr/share/freeswitch/sounds/music/default/16000'
end

link '/usr/share/freeswitch/sounds/music/32000' do
  to '/usr/share/freeswitch/sounds/music/default/32000'
end


