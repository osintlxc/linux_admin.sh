#!/bin/bash
#Author  Vignesh_ragupathy@yahoo.com

for server in `cat serverlist.txt`
do
ssh -t $server "sudo passwd username <<EOF
IMS_un2x
IMS_un2x
EOF"
done
