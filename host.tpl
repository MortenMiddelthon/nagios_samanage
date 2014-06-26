define host{
        use		TEMPLATE
        host_name	HOSTNAME
        alias		HOSTNAME - DESC
        address		ADDRESS
	hostgroups	+HOSTGROUPS

#        icon_image       base/IMAGE.png
#        icon_image_alt   OPERATINGSYSTEM
#        statusmap_image  base/IMAGE.gd2
	notes_url	NOTES
	parents		PARENTS
        }
