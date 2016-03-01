Geoserver-tomcat Cookbook
=============
Installs and configures geoserver to run on tomcat application server.

Requirements
============

## Platforms

* Ubuntu 14.04 LTS

Tested on:

* Ubuntu 14.04 LTS


### Cookbooks
Requires the following cookbooks
* `application_java`
* `database`
* `postgresql`
* `postgis`
* `tomcat`


Attributes
============
* `node[:geoserver][:version]`  -  The version of geoserver to install.
* `node[:geoserver][:workingDir]` - The temporary working directory for downloading and extracting geoserver archive.

* `node[:geoserver][:link]`  - The geoserver compressed archive link.
* `node[:geoserver][:home]` - The directory where geoserver war would be hosted and deployed to tomcat.
* `node[:geoserver][:data]`  - Geoserver data directory.
* `node[:geoserver][:context]`  - Geoserver context path on tomcat.

## Postgresql related attributes
* `node[:geoserver][:database]` - The name of the postgresql database.
* `node[:geoserver][:database-user]` - The name of the database user.
* `node[:geoserver][:database-password]` - The password for the database user.

Recipes
=======
* `default.rb` - Downloads geoserver and deploys it to tomcat.
* `postgresql.rb` - Creates postgresql database and user  for geoserver. Alos installs postgis extensions to this database.

Chef Solo Note
==============

You can install geoserver on tomcat as follows.

Create a file geoserver.json with the following contents. 

    {
        "geoserver-tomcat": {
            "data": "/usr/local/geoserver-data",
            "database": "geoserver",
            "database-user": "geoserver",
            "database-password": "suerpsecretpassword"
        },
        "postgresql": {
            "password": {
                "postgres": "postgres123"
            }
        },
        "tomcat": {
            "base_version": "7"
        },
        "java": {
            "jdk_version": "7"
        },
        "run_list": [
            "recipe[geoserver-tomcat]"
        ]
    }

Test Kitchen
============
Test kitchen is setup using the kitchen docker-driver. Install it with:
```
chef gem install kitchen-docker
```

Port forwarding.
The 3 boxes created by test kitchen have the bellow port 80 forwarding.
Ubuntu 14.04, 8081
CentOS 7, 8082
CentOS 6, 8080

License and Author
==================

- Author:: Ashish Shinde (<ashish@strandls.com>)
- Author:: Sandeep Tadekar (<sandeept@strandls.com>)
- Author:: Prabhakar Rajagopal (<prabha@strandls.com>)
- Author:: Josh Beauregard (<josh_beauregard@harvard.edu>))

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
