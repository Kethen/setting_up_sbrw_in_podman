# based on https://github.com/berkayylmao
set -xe

server=${1:-127.0.0.1}

BUILT_DIR=${BUILT_DIR:-/soap/built}
DB=${DB:-mariadb}

echo "starting $DB"
${DB}d -u root --lower-case-table-names=1 &
DB_PID=$!


while [ -z "$(ss -tuapn | grep 127.0.0.1:3306)" ]
do
	sleep 0.5
done

sleep 10

bash /scripts/set_server_address.sh $server
bash /scripts/enable_modding.sh $server
bash /scripts/change_openfire_server.sh $server

start_openfire () {
	cd "$BUILT_DIR"/openfire
	export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
	export OPENFIRE_HOME="$BUILT_DIR"/openfire
	$JAVA_HOME/bin/java -server -Djsse.enableCBCProtection=false -DopenfireHome="$OPENFIRE_HOME" -Dlog4j.configurationFile="$OPENFIRE_HOME/lib/log4j2.xml" -Dopenfire.lib.dir="$OPENFIRE_HOME/lib"  -jar "$OPENFIRE_HOME"/lib/startup.jar
}

start_freeroam () {
	cd "$BUILT_DIR"/freeroam
	./freeroamd
}

start_race () {
	cd "$BUILT_DIR"/race
	export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
	$JAVA_HOME/bin/java -jar race.jar 9998
	#./race
}

start_core () {
	export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
	cd "$BUILT_DIR"/core
	$JAVA_HOME/bin/java -jar core.jar
}

start_http () {
	cd /http_root
	php -S 0.0.0.0:8081
}

respawn () {
	command=$1
	log_file=$2
	while true
	do
		echo starting "$command"
		mv /logs/${log_file} /logs/${log_file}.old || true
		$command 1>/logs/${log_file} 2>&1 || true
		echo "$command" died, restarting
	done
}

respawn start_openfire openfire &
respawn start_freeroam freeroam &
respawn start_race race &
respawn start_http http &

sleep 10

respawn start_core core &
