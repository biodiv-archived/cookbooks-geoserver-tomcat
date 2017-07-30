name             'geoserver-tomcat'
maintainer       'Strand Life Sciences'
maintainer_email 'ashish@strandls.com'
license          'Apache License, Version 2.0'
description      'Installs/Configures geoserver on Tomcat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends          'cerner_tomcat'
depends          'database'
depends          'postgresql'
