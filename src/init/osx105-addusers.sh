#! /bin/bash
# By Spransy, Derek" <DSPRANS () emory ! edu> and Charlie Scott
#
# alterations by bil hays 2013
# -Switched to bash
# -Added some sanity checks
# -Added routine to find the first 3 contiguous UIDs above 100,
#  starting at 600 puts this in user space
# -Added lines to append the ospatrol users to the group ospatrol
#  so the the list GroupMembership works properly

#####
# This checks for an error and exits with a custom message
# Returns zero on success
# $1 is the message
# $2 is the error code

if [[ ! -f "/usr/bin/dscl" ]]
  then
  echo "Error, I have no dscl, dying here";
  exit
fi

DSCL="/usr/bin/dscl";

function check_errm
   {
   if  [[ ${?} != "0" ]]
      then
      echo "${1}";
      exit ${2};
      fi
   }

# get unique id numbers (uid, gid) that are greater than 100
unset -v i new_uid new_gid idvar;
declare -i new_uid=0 new_gid=0 i=100 idvar=0;
while [[ $idvar -eq 0 ]]; do
   i=$[i+1]
   j=$[i+1]
   k=$[i+2]
   if [[ -z "$(/usr/bin/dscl . -search /Users uid ${i})" ]] && [[ -z "$(/usr/bin/dscl . -search /Groups gid ${i})" ]] && \
      [[ -z "$(/usr/bin/dscl . -search /Users uid ${j})" ]] && [[ -z "$(/usr/bin/dscl . -search /Groups gid ${j})" ]] && \
      [[ -z "$(/usr/bin/dscl . -search /Users uid ${k})" ]] && [[ -z "$(/usr/bin/dscl . -search /Groups gid ${k})" ]];
      then
      new_uid=$i
      new_gid=$i
      idvar=1
      #break
   fi
done

echo "UIDs available are:";
echo ${new_uid}
echo ${j}
echo ${k}

# Verify that the uid and gid exist and match
if [[ $new_uid -eq 0 ]] || [[ $new_gid -eq 0 ]];
   then
   echo "Getting unique id numbers (uid, gid) failed!";
   exit 1;
   fi
if [[ ${new_uid} != ${new_gid} ]]
   then
   echo "I failed to find matching free uid and gid!";
   exit 5;
   fi


# Creating the groups.
sudo ${DSCL} localhost -create /Local/Default/Groups/ospatrol
check_errm "Error creating group ospatrol" "67"
sudo ${DSCL} localhost -createprop /Local/Default/Groups/ospatrol PrimaryGroupID ${new_gid}
sudo ${DSCL} localhost -createprop /Local/Default/Groups/ospatrol RealName ospatrol
sudo ${DSCL} localhost -createprop /Local/Default/Groups/ospatrol RecordName ospatrol
sudo ${DSCL} localhost -createprop /Local/Default/Groups/ospatrol RecordType: dsRecTypeStandard:Groups
sudo ${DSCL} localhost -createprop /Local/Default/Groups/ospatrol Password "*"


# Creating the users.

if [[ $(dscl . -read /Users/ospatrolm) ]]
   then
   echo "ospatrolm already exists";
else
   sudo ${DSCL} localhost -create /Local/Default/Users/ospatrolm
   check_errm "Error creating user ospatrolm" "87"
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolm RecordName ospatrolm
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolm RealName "ospatrolmacct"
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolm NFSHomeDirectory /var/ospatrol
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolm UniqueID ${j}
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolm PrimaryGroupID ${new_gid}
   sudo ${DSCL} localhost -append /Local/Default/Groups/ospatrol GroupMembership ospatrolm
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolm Password "*"
fi

if [[ $(dscl . -read /Users/ospatrolr) ]]
   then
   echo "ospatrolr already exists";
else
   sudo ${DSCL} localhost -create /Local/Default/Users/ospatrolr
   check_errm "Error creating user ospatrolr" "97"
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolr RecordName ospatrolr
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolr RealName "ospatrolracct"
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolr NFSHomeDirectory /var/ospatrol
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolr UniqueID ${k}
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolr PrimaryGroupID ${new_gid}
   sudo ${DSCL} localhost -append /Local/Default/Groups/ospatrol GroupMembership ospatrolr
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrolr Password "*"
fi

if [[ $(dscl . -read /Users/ospatrol) ]]
   then
   echo "ospatrol already exists";
else
   sudo ${DSCL} localhost -create /Local/Default/Users/ospatrol
   check_errm "Error creating user ospatrol" "77"
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrol RecordName ospatrol
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrol RealName "ospatrolacct"
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrol NFSHomeDirectory /var/ospatrol
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrol UniqueID ${new_uid}
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrol PrimaryGroupID ${new_gid}
   sudo ${DSCL} localhost -append /Local/Default/Groups/ospatrol GroupMembership ospatrol
   sudo ${DSCL} localhost -createprop /Local/Default/Users/ospatrol Password "*"
fi


