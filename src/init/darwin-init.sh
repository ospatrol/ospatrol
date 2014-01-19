#!/bin/sh
# Darwin init script.
# by Lorenzo Costanzia di Costigliole <mummie@tin.it>

mkdir -p /Library/StartupItems/OSPatrol
cat <<EOF >/Library/StartupItems/OSPatrol/StartupParameters.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://
www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
       <key>Description</key>
       <string>OSPatrol Host-based Intrusion Detection System</string>
       <key>Messages</key>
       <dict>
               <key>start</key>
               <string>Starting OSPatrol</string>
               <key>stop</key>
               <string>Stopping OSPatrol</string>
       </dict>
       <key>Provides</key>
       <array>
               <string>OSPatrol</string>
       </array>
       <key>Requires</key>
       <array>
               <string>IPFilter</string>
       </array>
</dict>
</plist>
EOF

cat <<EOF >/Library/StartupItems/OSPatrol/OSPatrol
#!/bin/sh

. /etc/rc.common
. /etc/ospatrol-init.conf
if [ "X\${DIRECTORY}" = "X" ]; then
    DIRECTORY="/var/ospatrol"
fi


StartService ()
{
        \${DIRECTORY}/bin/ospatrol-control start
}

StopService ()
{
        \${DIRECTORY}/bin/ospatrol-control stop
}

RestartService ()
{
        \${DIRECTORY}/bin/ospatrol-control restart
}

RunService "\$1"
EOF
chmod 755 /Library/StartupItems/OSPatrol
chmod 644 /Library/StartupItems/OSPatrol/StartupParameters.plist
chmod 755 /Library/StartupItems/OSPatrol/OSPatrol
