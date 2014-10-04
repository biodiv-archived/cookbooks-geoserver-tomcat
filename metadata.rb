name             'geoserver-tomcat'
maintainer       'Strand Life Sciences'
maintainer_email 'ashish@strandls.com'
license          'Apache License, Version 2.0'
description      'Installs/Configures geoserver on Tomcat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ java tomcat }.each do |cb|
  depends cb
end

depends          'application_java'
depends          'database'
depends          'postgresql'
depends          'postgis'
