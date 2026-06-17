## setting_up_sbrw_in_podman

### Starting server

The sbrw stack is pretty particular with ip addresses. This is the full steps for starting the server on eg. 192.168.1.107, your LAN ip.
Keep in mind that everytime the IP changes, you have to do this whole dance. DNS tricks might help.

1. change `openfire_conf/openfire.xml`, find tag `<setup>` and change the body to `false`
2. start server shell run `bash run_podman.sh` in the project directory, note that first run will take a moment to build all projects and the container image
3. run `bash /scripts/start_sbrw.sh`
4. navigate to `http://127.0.0.1:9090` in a browser, you will be greeted with the setup page
5. change `XMPP Doman Name` and `Server Host Name (FQDN)` to the IP address you want to host on, in this case, `192.168.1.107`
6. follow the instructions, you generally don't have to change any fields at this moment
7. once you have went through the setup wizard, you can close the browser window
8. back to the server shell, run `exit` to stop the server
9. start server shell once again, run `bash run_podman.sh` in the project directory
10. run `bash /scripts/start_sbrw.sh 192.168.1.107` in the server shell

Now your server should be available on `192.168.1.107`. To stop the server, run `exit` in the server shell

To start the server again on the same IP address, repeat step 9 and 10. The full procedure has to be done when the IP address is changed. `127.0.0.1` can be used when running the server exclusively for the local machine.

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
