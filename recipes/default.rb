#
# Cookbook Name:: geoserver-tomcat
# Recipe:: default
#
# Copyright 2014, Strand Life Sciences
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "java"

package "unzip" do
  action :install
end

remote_file node.geoserver.download do
  source   node.geoserver.link
  mode     0644
  action :create_if_missing
end

bash 'unpack geoserver' do
  code <<-EOH
  mkdir "#{node.geoserver.extracted}"
  unzip  #{node.geoserver.download} -d #{node.geoserver.extracted}
  EOH
  not_if "test -d #{node.geoserver.extracted}"
end

bash "Creating temporary working directory" do
  code <<-EOH
  mkdir -p /tmp/geoserver-temp/WEB-INF/lib
  EOH
end

remote_directory "Extract amdb jar" do
  path "/tmp/geoserver-temp/WEB-INF/lib"
  source "geoserver-lib"
end

bash "Adding amdb jar to  geoserver  war file #{node.geoserver.war}" do
  code <<-EOH
  cd /tmp/geoserver-temp
  jar -uvf #{node.geoserver.war} WEB-INF/lib
  chmod +r #{node.geoserver.war}
  cd -
  rm -rf /tmp/geoserver-temp
  EOH
end

# Setup user/group
poise_service_user "tomcat user" do
  user "tomcat"
  group "tomcat"
  shell "/bin/bash"
end

cerner_tomcat node.geoserver.tomcat_instance do
  version "7.0.54"
  web_app "geoserver" do
    source "file://#{node.geoserver.war}"

    template "META-INF/context.xml" do
      source "geoserver.context.erb"
    end
  end

  java_settings("-Xms" => "512m",
                "-D#{node.biodiv.appname}_CONFIG_LOCATION=".upcase => "#{node.biodiv.additional_config}",
                "-D#{node.fileops.appname}_CONFIG=".upcase => "#{node.fileops.additional_config}",
                "-Dlog4jdbc.spylogdelegator.name=" => "net.sf.log4jdbc.log.slf4j.Slf4jSpyLogDelegator",
                "-Dfile.encoding=" => "UTF-8",
                "-Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=" => "true",
                "-Xmx" => "4g",
                "-XX:PermSize=" => "512m",
                "-XX:MaxPermSize=" => "512m",
                "-XX:+UseParNewGC" => "")

end

remote_directory node.geoserver.data do
  source       "data_dir"
  owner        "tomcat"
  group        "tomcat"
  files_owner  "tomcat"
  files_group  "tomcat"
  files_backup 0
  files_mode   "644"
  purge        true
  action       :create_if_missing
  recursive true
  notifies :run, "execute[change-permission-#{node.geoserver.data}]", :immediately
  not_if       { File.exists? node.geoserver.data }
end

execute "change-permission-#{node.geoserver.data}" do
  command "chown -R tomcat:tomcat #{node.geoserver.data}"
  user "root"
  action :nothing
end
