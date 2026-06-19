set -xe

server=$1

echo setting server to $server

DB=${DB:-mariadb}

set_parameter () {
	name=$1
	value=$2
	sql="
		use soapbox;
		insert into parameter (name, value) values ('$name', '$value')
		on duplicate key update value='$value';
	"
	$DB <<< $(echo "$sql")
}

set_parameter UDP_FREEROAM_IP $server
set_parameter UDP_RACE_IP $server
set_parameter XMPP_IP $server
set_parameter SERVER_ADDRESS http://${server}:8081
set_parameter SERVER_INFO_BANNER_URL http://${server}:8081/banner.png
