#! /bin/bash
# Script to Deploy authorized_keys stores to users
# authorized_keys files should be in a "users" directory with script
# each authorized_keys file must be named the username you wish to deploy for.

# 'set -x' tells bash to output commands to stderr,
# thus making it visible in jenkins console output.
set -x

# set variable for users folder located with this script
usrkeydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/users/

# Search for username in access groups
function fncheckaccess {
	boolGranted=1
	for i in $(awk -F" " '/.*ingroup.*/{print $6}' /etc/pam.d/password-auth-ac)
		do getent group $i | grep -E "\b$1\b" >/dev/null 2>&1 && boolGranted=0
	done
	return $boolGranted
}

# write authorized_keys file
function fnwritekey {
	su $1 -c \
		"mkdir -p ~/.ssh; \
		cp $usrkeydir$1 ~/.ssh/authorized_keys; \
		chmod 700 ~/.ssh; \
		chmod 600 ~/.ssh/authorized_keys"	
}

# for each "username file" in users check access, 
# if granted write authorized_keys file for user account.
for usrnm in $usrkeydir*;
do
        if fncheckaccess $(basename $usrnm); then
		fnwritekey $(basename $usrnm);
	fi
done
