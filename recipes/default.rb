#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# Update the sources list
apt_update("update_sources") do
  action [:update]
end

# Install nginx
package("nginx") do
  action :install
end

# Create a proxy.conf file in the nginx sites-available folder on the VM using proxy.conf.erb template
template("/etc/nginx/sites-available/proxy.conf") do
  source "proxy.conf.erb"
  notifies(:restart, "service[nginx]")
end

# Link the proxy.conf file in sites-available to sites-enabled
link("/etc/nginx/sites-enabled/proxy.conf") do
  to "/etc/nginx/sites-available/proxy.conf"
  notifies(:restart, "service[nginx]")
end

# Remove the default conf file so nginx will use proxy.conf
link("/etc/nginx/sites-enabled/default") do
  action :delete
  notifies(:restart, "service[nginx]")
end

# Enable and start nginx
service("nginx") do
  action [:enable, :start]
end
