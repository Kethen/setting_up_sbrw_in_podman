set -xe

server=$1

echo enabling modding with $server as the server

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

set_parameter MODDING_BASE_PATH http://${server}:8081
set_parameter MODDING_ENABLED true
set_parameter MODDING_FEATURES ""
set_parameter MODDING_SERVER_ID ea472066-ae4c-4fbb-bcd6-75e4e518d85f
