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

# migrate from v2.1.0 to reloaded v20260704-203130
for f in 0001-BADGE_DEFINITION.sql 0002-SBRWR_KEEP_CAR_PERSONA.sql 0004-NOPOWERUPS.sql 0005-USERSTATUS.sql 0006-REPORT_UPDATE.sql 0007-ONLINEUSERS.sql 0008-CARCLASSLIST.sql 0009-ISADMIN_PRODUCT.sql 0010-EVENTDATASETUPS.sql 0011-LIVERYSTORE.sql 0013-UPDATE-RACENOW_PERSISTENT_PARAMETERS.sql 0014-ADD_CAR_RESTRICTION_TO_EVENT.sql 0015-ADD_SOCIAL_SETTINGS_TO_USER.sql 0015-FIX_SOCIAL_SETTINGS_COLUMNS.sql 0016-MODIFY_SOCIAL_SETTINGS_TYPES.sql 0017-FIX_SOCIAL_SETTINGS_NULLS.sql 0018-ADD_NEXTEVENTID_TO_EVENT_SESSION.sql 0018-ADD_RACENOW_AUTO_LOBBY_PARAM.sql 0019-ADD_LOBBY_LOCKED_CAR_CLASS.sql
do
	$DB --skip-password <<< $(echo $db_to_use; cat "$SRC_DIR"/SBRW-Reloaded-Core/sql_scripts/$f);
done

# add class list
$DB --skip-password <<< $(echo "insert into soapbox.parameter(name, value) values('CAR_CLASS_LIST', '869393278|0|49|F;872416321|50|249|E;415909161|250|399|D;1866825865|400|499|C;-406473455|500|599|B;-405837480|600|749|A;-2142411446|750|999|S;86241155|1000|1249|S1;221915816|1250|1499|S2;1526233495|1500|1999|S3;');")

# set xmpp provider
$DB --skip-password <<< $(echo "insert into soapbox.parameter(name, value) values('XMPP_PROVIDER', 'OPENFIRE');")

kill $DB_PID
wait $DB_PID
