nagios_samanage
===============

Nagios plugins for integrating with samanage

The scripts have been developed and used on Debian GNU/Linux 6.x and 7.x,
but should be adaptable to most Unix/Linux type platforms.

Script and plugins are all compatible with icinga

Requirements:
=============
perl 5.x with the following modules:
	Config::IniFiles 
	XML::LibXML
	DBI
	POSIX
	Time::HiRes

MySQL or MariaDB

Nagios 3.x or Icinga

Installation on Debian:
=======================

```bash
$ sudo apt-get -y install libconfig-inifiles-perl  libdbi-perl  libxml-libxml-perl  libtimedate-perl  libdbd-mysql-perl  mysql-clientmysql-common  mysql-server  ndoutils-nagios3-mysql  nagios3  nagios3-cgi  nagios3-common  nagios3-core
```

Initial configuration:
======================
Copy the default configuration file to a local version:

```bash
$ cp config.default.ini config.ini
```

Go through the settings and make sure they match your local
environment

Database setup:
===============
The scripts uses two databases. One database called 'SAM' which stores information retrieved from SAM. 
See the included SAM.sql for a complete database dump:

```bash
$ mysqladmin -uroot -p create SAM

$ mysql -uroot -p SAM < SAM.sql

$ mysql -e 'grant all on SAM.* to SAM@localhost identified by "yoursecretpassword"' -uroot -p
```

The username and password defined in the statement above must be stored on your
config.ini

The second the database is the one created by NDOUtils. The script only needs read access to 
the comments table, f.ex nagios_comments. The values needed to connect to the ndoutils database
is defined in the config.ini:

```bash
$ mysql -e 'grant select on ndoutils.nagios_comments to nagios@localhost identified by "yoursecretpassword"' -uroot -p
```

Nagios setup:
=============
See the included nagios.cfg for examples of command, service and contact definitions.
Make sure the paths and configuration values match your nagios setup

The import script expects some directories to be created under your nagios base configuration. F.ex

```bash
$ cd /etc/nagios3 && mkdir -p import/hosts import/services import/templates import/cache
```

The script uses a template file to create nagios host objects, host.tpl. Make sure this file
is located in your import/templates/ directory
