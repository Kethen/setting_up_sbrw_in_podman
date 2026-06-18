set -xe

IMAGE_TAG=setting_up_sbrw

if ${UPDATE_IMAGE:-false}
then
	podman image rm $IMAGE_TAG || true
fi

if ! podman image exists $IMAGE_TAG
then
	podman image build -t $IMAGE_TAG -f Dockerfile --no-cache --layers=false
fi

mkdir -p db
mkdir -p logs
mkdir -p http_root

INTERNAL_PORTS=""
# openfire panel
for p in 9090 9091
do
	INTERNAL_PORTS="$INTERNAL_PORTS -p 127.0.0.1:$p:$p"
done

# sbrw panel
INTERNAL_PORTS="$INTERNAL_PORTS -p 127.0.0.1:9990:9990"

EXTERNAL_PORTS=""
# racer sync
for p in 9998 9999
do
	EXTERNAL_PORTS="$EXTERNAL_PORTS -p $p:$p/udp"
done

# openfire
for p in 5222 5223 5262 5263 5276 5275 5270 5269 7070 7777
do
	EXTERNAL_PORTS="$EXTERNAL_PORTS -p $p:$p"
done

# soapbox
for p in 8080
do
	EXTERNAL_PORTS="$EXTERNAL_PORTS -p $p:$p"
done

# http
for p in 8081
do
	EXTERNAL_PORTS="$EXTERNAL_PORTS -p $p:$p"
done

podman run \
	--rm -it \
	--security-opt label=disable \
	--entrypoint /bin/bash \
	`#-v ./scripts:/scripts:ro` \
	-v ./db:/var/lib/mysql \
	-v ./logs:/logs \
	-v ./http_root:/http_root \
	-v ./openfire_conf:/soap/built/openfire/conf \
	$INTERNAL_PORTS \
	$EXTERNAL_PORTS \
	$IMAGE_TAG
