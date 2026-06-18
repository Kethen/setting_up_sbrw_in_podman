## setting_up_sbrw_in_podman

### Starting server

For example starting a server on `192.168.1.107`

1. start server shell by running `bash run_podman.sh` in the project directory, note that the first launch will take a moment to build the container image
2. run `bash /scripts/start_sbrw.sh 192.168.1.107` in the server shell

Now your server should be available on `192.168.1.107`. To stop the server, run `exit` in the server shell

### Updating server

Not sure what has to be done yet, feels like it'll be messy especially with data base schema changes. TBD

### Connecting

add `http://<server ip>:8080/Engine.svc` to sbrw launcher

If you are using the 2.2.4 linux build and can't add custom server, grab this version here for now https://github.com/Kethen/GameLauncher_NFSW/releases/tag/2026-06-17

### Rough configuration notes

- this is mostly for local testing and quick lan parties
- if you deploy this on the internet, you likely want to change some of these
- if you deploy this on lan, you have to make sure openfire and soapbox is using the correct ip address
	- For openfire, restart the setup process as described below
	- For soapbox, start the server as described below

#### Openfire

- admin email: admin@example.com
- admin login: admin
- admin pw: 12345678
- db connection: jdbc:mysql://localhost:3306/OPENFIRE?rewriteBatchedStatements=true&characterEncoding=UTF-8&characterSetResults=UTF-8&serverTimezone=UTC
- sqluser: openfire
- sqlpw: OPENFIRE-SQL-PASSWORD
- (system properties) adminConsole.access.allow-wildcards-in-excludes -> true for restapi to work on newer versions of openfire, the current version built in this repo does not have this property
- disable compression for some reason
- Inband Account Registration disabled
- restapi token: InsertOpenfireTokenHere
- to change the xmpp domain, one would normally have to re-run the setup, which can be done by changing /openfire_conf/openfire.xml <setup> from true to false, but changing openfire.xml seems to be enough in most cases

#### Soapbox

(project-defaults.yml)
- sqluser: soapbox
- sqlpw: SOAPBOX-SQL-PASSWORD

#### Ports

see run_podman.sh, things that should not be on the internet are generally bound to 127.0.0.1 only, unless a mistake was made
