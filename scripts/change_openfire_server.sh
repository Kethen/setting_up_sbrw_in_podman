set -xe
server=$1

sed -iE "s#<fqdn>.*</fqdn>#<fqdn>$server</fqdn>#" /soap/built/openfire/conf/openfire.xml
mariadb <<< $(echo "update openfire.ofproperty set propValue='$server' where name='xmpp.domain'")
