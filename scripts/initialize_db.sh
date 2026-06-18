# based on https://github.com/berkayylmao
set -xe

DB=${DB:-mariadb}

SRC_DIR=${SRC_DIR:-/soap/src}

if [ "$DB" == mariadb ]
then
	mariadb-install-db -u root --lower-case-table-names=1
else
	${DB}d --initialize-insecure --lower-case-table-names=1 -u root
fi

${DB}d -u root --lower-case-table-names=1 &
DB_PID=$!

while [ -z "$(ss -tuapn | grep 127.0.0.1:3306)" ]
do
	sleep 0.5
done

sleep 5

# setup database from setting-up-sbrw
$DB --skip-password <<< $(cat /scripts/sql/*)

db_to_use="use soapbox;"

# migrate from v2.0.? to v2.1.0
$DB --skip-password <<< $(echo $db_to_use; cat "$SRC_DIR"/soapbox-race-core/migrations/v200-v210/18*.sql "$SRC_DIR"/soapbox-race-core/migrations/v200-v210/19*.sql "$SRC_DIR"/soapbox-race-core/migrations/v200-v210/20*.sql "$SRC_DIR"/soapbox-race-core/migrations/v200-v210/21*.sql "$SRC_DIR"/soapbox-race-core/migrations/v200-v210/25*.sql "$SRC_DIR"/soapbox-race-core/migrations/v200-v210/26*.sql)

# add class list
$DB --skip-password <<< $(echo "insert into soapbox.parameter(name, value) values('CAR_CLASS_LIST', '872416321|0|249|E;415909161|250|399|D;1866825865|400|499|C;-406473455|500|599|B;-405837480|600|749|A;-2142411446|750|65534|S');")

kill $DB_PID
wait $DB_PID
