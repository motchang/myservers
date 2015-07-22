#
# Cookbook Name:: common-packages
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package ['htop', 'dstat', 'zsh', 'perl-XML-XPath'] do
  action :upgrade
end
