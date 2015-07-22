#
# Cookbook Name:: net-radio-archive
# Recipe:: default
## Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'yum-remi'
include_recipe 'yum-epel'

yum_repository 'rpmforge' do
  mirrorlist 'http://mirrorlist.repoforge.org/el6/mirrors-rpmforge'
  description 'RHEL $releasever - RPMforge.net - dag'
  enabled true
  gpgcheck true
  gpgkey 'http://apt.sw.be/RPM-GPG-KEY.dag.txt'
end

package ['kernel', 'kernel-headers', 'mysql-libs', 'mysql', 'mysql-server', 'mysql-devel', 'rtmpdump', 'swftools', 'ffmpeg', 'nodejs'] do
  action :upgrade
end

service 'mysqld' do
  action [:enable, :start]
end

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

rbenv_ruby "2.2.2" do
  global true
  ruby_version "2.2.2"
end

execute "sudo -i -u #{node['rbenv']['user']} gem install bundler"

directory '/var/lib/net-radio' do
  owner 'motchang'
  group 'motchang'
  mode '0755'
  action :create
end

git '/var/lib/net-radio' do
  repository "https://github.com/yayugu/net-radio-archive.git"
  revision "master"
  user "motchang"
  group "motchang"
  action :sync
end

execute 'update submodule' do
  cwd '/var/lib/net-radio'
  user 'motchang'
  command 'git submodule update --init --recursive'
end

execute 'bundle install' do
  cwd '/var/lib/net-radio'
  user 'motchang'
  command 'bundle install --path=vendor/bundle --without development test'
end

template '/var/lib/net-radio/config/database.yml' do
  source 'database.yml.erb'
  mode '0644'
  owner 'motchang'
  group 'motchang'
  action :create
end

template '/var/lib/net-radio/config/settings.yml' do
  source 'settings.yml.erb'
  mode '0644'
  owner 'motchang'
  group 'motchang'
  action :create
end

execute 'migrate' do
  cwd '/var/lib/net-radio'
  user 'motchang'
  command 'RAILS_ENV=production bundle exec rake db:create db:migrate'
end

execute 'crontab' do
  cwd '/var/lib/net-radio'
  user 'motchang'
  command 'bundle exec whenever --update-crontab'
end
