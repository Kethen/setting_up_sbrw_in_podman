# based on https://github.com/berkayylmao
set -xe

SRC_DIR=${SRC_DIR:-/soap/src}
BUILT_DIR=${BUILT_DIR:-/soap/built}

mkdir -p "$BUILT_DIR"


echo "Building SBRW-Core..."
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
cd "$SRC_DIR"/soapbox-race-core
# workaround not having that data on hand at all
sed -i 's/throw new RuntimeException("CAR_CLASS_LIST parameter must be set");/carClassList = List.of("872416321|0|249", "415909161|250|399", "1866825865|400|499", "-406473455|500|599", "-405837480|600|749", "-2142411446|750|65534");/' src/main/java/com/soapboxrace/core/bo/PerformanceBO.java
mvn clean package
mkdir -p "$BUILT_DIR"/core
if ! [ -e "$BUILT_DIR"/core/project-defaults.yml ]
then
	sed -i 's/password: secret/password: SOAPBOX-SQL-PASSWORD/' project-defaults.yml
	cp project-defaults.yml "$BUILT_DIR"/core/project-defaults.yml
fi
cp target/core-thorntail.jar "$BUILT_DIR"/core/core.jar

echo "Building WUGG-Freeroam..."
cd "$SRC_DIR"/freeroam/cmd/freeroamd
go build freeroamd.go
mkdir -p "$BUILT_DIR"/freeroam
cp freeroamd "$BUILT_DIR"/freeroam/
#cp config.toml "$BUILT_DIR"/freeroamd

if false
then
	echo "Copying Nilzao-RaceSync..."
	cd "$SRC_DIR"/sbrw-mp-sync-2018
	mkdir -p "$BUILT_DIR"/race/keys
	cp sbrw-mp.jar "$BUILT_DIR"/race/race.jar
fi

echo "Building WUGG-Race..."
cd "$SRC_DIR"/sbrw-race-go
go build main.go
mkdir -p "$BUILT_DIR"/race
cp main "$BUILT_DIR"/race/race

echo "============= SBRW Projects Completed ============="

echo "Building Openfire..."
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
cd "$SRC_DIR"/openfire
sed -i 's#https://maven.atlassian.com/repository/public#https://repo1.maven.org/maven2#' xmppserver/pom.xml
sed -i 's#<dependencies>#<dependencies><dependency><groupId>javax.xml.bind</groupId><artifactId>jaxb-api</artifactId><version>2.3.1</version></dependency>'<dependency><groupId>org.glassfish.jaxb</groupId><artifactId>jaxb-runtime</artifactId><version>2.3.1</version><scope>runtime</scope></dependency>#' pom.xml
#sed -i 's/javax.xml.bind/jaxb-api/' xmppserver/pom.xml
mvn clean verify -pl distribution -am
cd distribution/target/distribution-base
mkdir -p "$BUILT_DIR"/openfire
if [ -e "$BUILT_DIR"/openfire/conf ]
then
	rm -r conf
fi
cp -r * "$BUILT_DIR"/openfire

echo "Building Openfire RestAPI Plugin..."
cd "$SRC_DIR"/openfire-restAPI-plugin
mvn clean package
cp target/restAPI-openfire-plugin-assembly.jar "$BUILT_DIR"/openfire/plugins/restAPI.jar

echo "Building Openfire Non-SASL Authentication Plugin..."
cd "$SRC_DIR"/openfire-nonSaslAuthentication-plugin
mvn clean package
cp target/nonSaslAuthentication-openfire-plugin-assembly.jar "$BUILT_DIR"/openfire/plugins/nonSaslAuthentication.jar

echo "============= Openfire Projects Completed ============="

echo "Done!"
