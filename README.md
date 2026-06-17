## setting_up_sbrw_in_podman

### Rough configuration notes

- this is mostly for local testing and quick lan parties
- if you deploy this on the internet, you likely want to change some of these
- if you deploy this on lan, you have to make sure openfire and soapbox is using the correct ip address
	- For openfire, restart the setup process as described below
	- For soapbox, start the server as described below

#### Openfire

admin email: admin@example.com
admin login: admin
admin pw: 12345678
db connection: jdbc:mysql://localhost:3306/OPENFIRE?rewriteBatchedStatements=true&characterEncoding=UTF-8&characterSetResults=UTF-8&serverTimezone=UTC
sqluser: openfire
sqlpw: OPENFIRE-SQL-PASSWORD

(system properties) adminConsole.access.allow-wildcards-in-excludes -> true for restapi to work on newer versions of openfire, the current version built in this repo does not have this property
disable compression for some reason
Inband Account Registration disabled
restapi token: InsertOpenfireTokenHere

to change the xmpp domain, one would have to re-run the setup, which can be done by changing /openfire_conf/openfire.xml <setup> from true to false
during the setup, 'Restrict Admin Console Access' is disable so that the setup page can be accessed outside of the container

#### Soapbox

(project-defaults.yml)
sqluser: soapbox
sqlpw: SOAPBOX-SQL-PASSWORD

soapbox had a single line change to cover our lack of car class list data in our schemas, see /scripts/build.sh

#### Ports

see run_podman.sh, things that should not be on the internet are generally bound to 127.0.0.1 only, unless a mistake was made

#### Starting server

`bash run_podman.sh`

#### Connecting

add http://127.0.0.1:8080/Engine.svc to sbrw launcher

If you are using the 2.2.4 linux build and can't add custom server, grab this version here for now https://github.com/Kethen/GameLauncher_NFSW/releases/tag/2026-06-17
