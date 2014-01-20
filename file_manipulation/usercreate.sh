#!/bin/bash
#Author  Vignesh_ragupathy@yahoo.com

for server in `cat serverlist.txt`
do
ssh -t $server sudo /usr/sbin/groupadd ims_unix
scp /home/sitescope/vignesh/sudoadd.sh $server:.
ssh -t $server sh sudoadd.sh
for user in `cat userlist.txt`
do
ssh -t $server sudo /usr/sbin/useradd -g ims_unix $user
ssh -t $server "sudo /usr/bin/passwd $user <<EOF
IMS_un1x
IMS_un1x
EOF"
ssh -t $server sudo /usr/bin/chage -m 0 -M 90 -W 7 $user
ssh -t $server sudo /usr/bin/chage -d 0 $user
done
done
