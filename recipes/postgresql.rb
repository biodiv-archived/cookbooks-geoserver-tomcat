#
# Cookbook Name:: geoserver-tomcat
# Recipe:: postgresql
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

include_recipe "postgresql::server"
include_recipe "postgresql::client"
include_recipe "database::postgresql"

postgresql_connection_info = {:host => "localhost",
                              :port => node['postgresql']['config']['port'],
                              :username => 'postgres',
                              :password => node['postgresql']['password']['postgres']}


# create a postgresql database
postgresql_database node.geoserver.database do
  connection postgresql_connection_info
  action :create
  notifies :query, "postgresql_database[create postgis extension]"
end


# create a postgresql user but grant no privileges
postgresql_database_user node['geoserver']['database-user'] do
  connection postgresql_connection_info
  password node['geoserver']['database-password']
  action :create
end

package "postgresql-#{node['postgresql']['version']}-postgis-scripts"

# setup postgis extension
postgresql_database 'create postgis extension' do
  connection      postgresql_connection_info
  database_name node.geoserver.database
  sql "CREATE EXTENSION if not exists postgis; CREATE EXTENSION if not exists postgis_topology; CREATE EXTENSION if not exists dblink;create or replace view observation_locations as SELECT obs.id, obs.source, obs.species_name, obs.topology FROM dblink('dbname=biodiv'::text, 'select id, source, species_name, topology from observation_locations'::text) obs(id bigint, source text, species_name character varying(255), topology geometry);"
  action :nothing
end


# grant all privileges on all tables in foo db
postgresql_database_user node['geoserver']['database-user'] do
  connection postgresql_connection_info
  database_name node.geoserver.database
  privileges [:all]
  action :grant
end
