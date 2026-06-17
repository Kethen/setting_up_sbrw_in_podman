# based on https://github.com/berkayylmao
set -xe
SRC_DIR=${SRC_DIR:-/soap/src}

rm -rf "$SRC_DIR"
mkdir -p "$SRC_DIR"

cd "$SRC_DIR"

clone_commit () {
	# git in ubuntu 24.04 don't have --revision while cloning
	url=$1
	commit=$2
	path=$(basename "$url")
	git clone $1
	cd "$path"
	git checkout $commit
	cd ..
}

# I'm starting to think that for the db to work, at least somewhat officially, it has to be v1.0.3 -> v2.0.0 -> v2.1.0
clone_commit https://github.com/WorldUnitedNFS/soapbox-race-core aa4eb561d83f4555adddc569865229d91171b59c
cd soapbox-race-core
git checkout v1.0.3 sql-new
cd ..
#clone_commit https://github.com/SoapboxRaceWorld/soapbox-race-core d3edcd002514eb5265ad44484d79c4d2541ab055
#git clone https://github.com/SoapboxRaceWorld/soapbox-race-core -b v1.0.3
#clone_commit https://github.com/VladManyanov/sbrw-mp-sync-2018 a847f5fc98c17715014962debf3a89f0d881a0ac
clone_commit https://github.com/WorldUnitedNFS/sbrw-race-go ac5cb6171f4a2013308f7355f4492bd1573869d4
clone_commit https://github.com/WorldUnitedNFS/freeroam ced3aca6e6230a59e3bf5fce457e69c3041f9e1c
clone_commit https://github.com/SoapboxRaceWorld/openfire 028873a1469331b5bcadbc689f610c8d6cda9d3a
#git clone https://github.com/igniterealtime/Openfire -b v4.8.3 openfire
clone_commit https://github.com/SoapboxRaceWorld/openfire-nonSaslAuthentication-plugin 05d9388c8205e9a02f82f87bd7618d07d385d968
#clone_commit https://github.com/SoapboxRaceWorld/openfire-restAPI-plugin a280cb9fdf450386ceb79f5200dbe37596f695e0
git clone https://github.com/igniterealtime/openfire-restAPI-plugin.git -b 1.4.0
clone_commit https://github.com/berkayylmao/setting-up-sbrw 2089af624f027ecce968a11aa050f3ace93aff43
