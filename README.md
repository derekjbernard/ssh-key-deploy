# ssh-key-deploy

I use this script to deploy authorized_keys for our users on our servers. Our users are directory services accounts and we use groups to grant access. Those groups are in /etc/pam.d/password-auth-ac.

Users authorized keys are in the users directory. Each file is named with the username. The contents of the file is simply the desired authorized_keys file for that user.

I simply pull the repo to the machine and run the script. It loops through the Users folder checking to see if each user is in one of the access groups, placing authorized_keys file for those that are in a group.

I currently use jenkins to automate this task, but will likely reproduce this functionality in a real configuration management solution soon. I posted this because a friend found the code useful. 
