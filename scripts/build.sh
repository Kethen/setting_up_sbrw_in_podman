# based on https://github.com/berkayylmao
set -xe

SRC_DIR=${SRC_DIR:-/soap/src}
BUILT_DIR=${BUILT_DIR:-/soap/built}

mkdir -p "$BUILT_DIR"


echo "Building SBRW-Core..."
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
cd "$SRC_DIR"/SBRW-Reloaded-Core
# workaround not having that data on hand at all
mvn clean package
mkdir -p "$BUILT_DIR"/core
if ! [ -e "$BUILT_DIR"/core/project-defaults.yml ]
then
	cp project-defaults.yml "$BUILT_DIR"/core/project-defaults.yml
fi
cp target/core-thorntail.jar "$BUILT_DIR"/core/core.jar

echo "Building WUGG-Freeroam..."
cd "$SRC_DIR"/freeroam/cmd/freeroamd
go build freeroamd.go
mkdir -p "$BUILT_DIR"/freeroam
cp freeroamd "$BUILT_DIR"/freeroam/
#cp config.toml "$BUILT_DIR"/freeroamd

if true
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
