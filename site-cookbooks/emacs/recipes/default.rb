#
# Cookbook Name:: emacs
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
directory '/usr/local/src do' do
  owner 'root'
  group 'wheel'
  mode '0777'
  action :create
end

remote_file '/usr/local/src/emacs-24.5.tar.gz' do
  source 'http://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz'
end

execute 'extract package' do
  cwd '/usr/local/src'
  command 'ls -l /usr/local/bin/emacs 1>/dev/null || tar xvfz emacs-24.5.tar.gz'
end

execute 'build emacs' do
  cwd '/usr/local/src/emacs-24.5'
  command 'ls -l /usr/local/bin/emacs 1>/dev/null || ./configure --prefix=/usr/local && make -j4 && make install'
end
