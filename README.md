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
apt-get -y install \
	libconfig-inifiles-perl \
	libdbi-perl \
	libxml-libxml-perl \
	libtimedate-perl \
	libdbd-mysql-perl \
	mysql-clientmysql-common \
	mysql-server \
	ndoutils-nagios3-mysql \
	nagios3 \
	nagios3-cgi \
	nagios3-common \
	nagios3-core

Initial configuration:
======================
Copy the default configuration file to a local version:
% cp config.default.ini config.ini

Go through the settings and make sure they match your local
environment

Database setup:
===============
The scripts uses two databases. One database called 'SAM' which stores information retrieved from SAM. 
See the included SAM.sql for a complete database dump:

% mysqladmin -uroot -p create SAM
% mysql -uroot -p SAM < SAM.sql
% mysql -e 'grant all on SAM.* to SAM@localhost identified by "yoursecretpassword"' -uroot -p

The username and password defined in the statement above must be stored on your
config.ini

The second the database is the one created by NDOUtils. The script only needs read access to 
the comments table, f.ex nagios_comments. The values needed to connect to the ndoutils database
is defined in the config.ini:

% mysql -e 'grant select on ndoutils.nagios_comments to nagios@localhost identified by 'yoursecretpassword' -uroot -p

Nagios setup:
=============
To use the scripts for automatically creating incidents with SAM use the following command definition.
Make sure to alter the paths for perl and the scripts. 

# 'notify-host-by-sam' command definition
define command{
        command_name    notify-host-by-sam
        command_line    <perl path> <script path>/sam_createcase --hostname=$HOSTNAME$ --type="$NOTIFICATIONTYPE$" --state=$HOSTSTATE$ --address=$HOSTADDRESS$ --output="$HOSTOUTPUT$" --date="$LONGDATETIME$"
        }

# 'notify-service-by-sam' command definition
define command{
        command_name    notify-service-by-sam
        command_line    <perl path> <script path>/sam_createcase --hostname=$HOSTNAME$ --type="$NOTIFICATIONTYPE$" --service="$SERVICEDESC$" --hostalias="$HOSTALIAS$" --address=$HOSTADDRESS$ --state="$SERVICESTATE$" --date="$LONGDATETIME$" --output="$SERVICEOUTPUT$"
        }

Also, create a contact object which uses these commands. Modify the notification periods and notification options
to your setup

# Create incident via samanage.com
define contact{
        contact_name                    sam
        alias                           samanage.com
        service_notification_period     24x7
        host_notification_period        24x7
        service_notification_options    w,u,c,r
        host_notification_options       d,r
        service_notification_commands   notify-service-by-sam
        host_notification_commands      notify-host-by-sam
        email                           <your email address>
        }

Included is a script to check the state and response time of SAM:

# Check availability and response time of sam
define command {
        command_name    check_sam
        command_line    <script path>/check_sam --response_warning=$ARG1$ --response_critical=$ARG2$
}

The service definition of this script is usually connected to the nagios host itself:

define service {
        host_name               <your nagios host>
        service_description     Check SAM incidents
        check_command           check_sam_incidents
        use                     generic-service
}

