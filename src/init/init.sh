#!/bin/sh
# Init functions for the OSPatrol
# v0.3
# Author: Daniel B. Cid <daniel.cid@gmail.com>
# Last modification: May 04, 2006 (by Kayvan A. Sylvan <kayvan@sylvan.com>)
# v0,2: Mar 03, 2006
# v0.1: Jan 01, 2005

UN=${NUNAME};

runInit()
{
    echo ""
    echo ""
    # Checking if it is a Redhat system.
    if [ -r "/etc/redhat-release" ]; then
        if [ -d /etc/rc.d/init.d ]; then
            echo " - ${systemis} Redhat Linux."
            echo " - ${modifiedinit}"
            cp -pr ./src/init/ospatrol-hids-rh.init /etc/rc.d/init.d/ospatrol
            chmod 555 /etc/rc.d/init.d/ospatrol
            chown root:ospatrol /etc/rc.d/init.d/ospatrol
            /sbin/chkconfig --add ospatrol > /dev/null 2>&1
            return 0;
        fi
    fi
    # Checking for Gentoo
    if [ -r "/etc/gentoo-release" ]; then
        echo " - ${systemis} Gentoo Linux."
        echo " - ${modifiedinit}"
        cp -pr ./src/init/ospatrol-hids-gentoo.init /etc/init.d/ospatrol
        chmod 555 /etc/init.d/ospatrol
        chown root:ospatrol /etc/init.d/ospatrol
        rc-update add ospatrol default
        return 0;
    fi    

    # Suse
    if [ -r "/etc/SuSE-release" ]; then
        echo " - ${systemis} Suse Linux."
        echo " - ${modifiedinit}"

        cp -pr ./src/init/ospatrol-hids-suse.init  /etc/init.d/ospatrol
        chmod 555 /etc/init.d/ospatrol
        chown root:ospatrol /etc/init.d/ospatrol

        /sbin/chkconfig --add ospatrol > /dev/null 2>&1
        return 0;
    fi
    
    # Checking for slackware (by Jack S. Lai)
    if [ -r "/etc/slackware-version" ]; then
        echo " - ${systemis} Slackware Linux."
        echo " - ${modifiedinit}"
        cp -pr ./src/init/ospatrol-hids.init /etc/rc.d/rc.ospatrol
        chmod 555 /etc/rc.d/rc.ospatrol
        chown root:ospatrol /etc/rc.d/rc.ospatrol

        grep ospatrol /etc/rc.d/rc.local > /dev/null 2>&1
        if [ $? != 0 ]; then
            echo "if [ -x /etc/rc.d/rc.ospatrol ]; then" >> /etc/rc.d/rc.local
            echo "      /etc/rc.d/rc.ospatrol start" >>/etc/rc.d/rc.local
            echo "fi" >>/etc/rc.d/rc.local
        fi    

        return 0;
    fi    
    
    # Darwin init script (by Lorenzo Costanzia di Costigliole <mummie@tin.it>)
    if [ "X${NUNAME}" = "XDarwin" ]; then
        # Generating darwin init script.

        echo " - ${systemis} Darwin."
        echo " - ${modifiedinit}"
        sh ./src/init/darwin-init.sh
        return 0;
    fi

    if [ "X${UN}" = "XSunOS" ]; then
        echo " - ${systemis} Solaris (SunOS)."
        echo " - ${modifiedinit}"
        cp -pr ./src/init/ospatrol-hids-solaris.init /etc/init.d/ospatrol
        chmod 755 /etc/init.d/ospatrol
        ln -s /etc/init.d/ospatrol /etc/rc2.d/S97ospatrol
        ln -s /etc/init.d/ospatrol /etc/rc3.d/S97ospatrol
        return 0;    
    fi    

    if [ "X${UN}" = "XAIX" ]; then
        echo " - ${systemis} AIX."
        echo " - ${modifiedinit}"
        cp -pr ./src/init/ospatrol-hids-aix.init /etc/init.d/ospatrol
        chmod 755 /etc/init.d/ospatrol
        ln -s /etc/init.d/ospatrol /etc/rc2.d/S97ospatrol
        ln -s /etc/init.d/ospatrol /etc/rc3.d/S97ospatrol
        return 0;    
    fi    

    if [ "X${UN}" = "XOpenBSD" -o "X${UN}" = "XNetBSD" -o "X${UN}" = "XFreeBSD" -o "X${UN}" = "XDragonFly" ]; then
        # Checking for the presence of ospatrol-control on rc.local
        grep ospatrol-control /etc/rc.local > /dev/null 2>&1
        if [ $? != 0 ]; then
            echo "echo \"${starting}\"" >> /etc/rc.local
            echo "${INSTALLDIR}/bin/ospatrol-control start" >> /etc/rc.local
        fi
        echo " - ${systemis} ${NUNAME}."
        echo " - ${modifiedinit}"
        return 0;
    elif [ "X${NUNAME}" = "XLinux" ]; then
        if [ -e "/etc/rc.d/rc.local" ]; then
            echo " - ${systemis} Linux."
            echo " - ${modifiedinit}"

            grep ospatrol-control /etc/rc.d/rc.local > /dev/null 2>&1
            if [ $? != 0 ]; then
                echo "echo \"${starting}\"" >> /etc/rc.d/rc.local
                echo "${INSTALLDIR}/bin/ospatrol-control start" >> /etc/rc.d/rc.local
            fi
            return 0;
        elif [ -d "/etc/rc.d/init.d" ]; then
            echo " - ${systemis} Linux (SysV)."
            echo " - ${modifiedinit}"
            cp -pr ./src/init/ospatrol-hids.init  /etc/rc.d/init.d/ospatrol
            chmod 555 /etc/rc.d/init.d/ospatrol
            chown root:ospatrol /etc/rc.d/init.d/ospatrol
            return 0;
        # Taken from Stephen Bunn ospatrol howto.    
        elif [ -d "/etc/init.d" -a -f "/usr/sbin/update-rc.d" ]; then
            echo " - ${systemis} Debian (Ubuntu or derivative)."
            echo " - ${modifiedinit}"
            cp -pr ./src/init/ospatrol-hids-debian.init  /etc/init.d/ospatrol
            chmod +x /etc/init.d/ospatrol
            chmod go-w /etc/init.d/ospatrol
            chown root:ospatrol /etc/init.d/ospatrol
            update-rc.d ospatrol defaults > /dev/null 2>&1
            return 0;    
        else
            echo " - ${noboot}"
        fi        
    else
        echo " - ${noboot}"
    fi
    
    return 1;        
}


# EOF 
