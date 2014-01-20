#!/bin/bash
#author vignesh_ragupathy@yahoo.com

mkdir -p /usr/local/stats/script_RB_check

###Check running services###
service --status-all |grep running... |awk '{print $1}' > /usr/local/stats/script_RB_check/b_services

##check network services ##
/etc/init.d/network status |grep active -A 1 |sed -n 2,5p >> /usr/local/stats/script_RB_check/b_services

###check iptables ###
/etc/init.d/iptables status |grep "Firewall is not running" > /dev/null
if [ $? != 0 ]; then
echo iptables >> /usr/local/stats/script_RB_check/b_services
fi
###check total memory###
free -m |grep Mem |awk '{print $2}' > /usr/local/stats/script_RB_check/b_memory

##check mounted volumes###
df -Ph |awk '{print $NF}' |sed -n 2,100p > /usr/local/stats/script_RB_check/b_mounted

#check sysctl values##
sysctl -a |grep -v kernel.random.uuid |grep -v random.entropy_avail |grep -v fs.inode |grep -v fs.dentry-state |perl -lape 's/\s+//sg'  > /usr/local/stats/script_RB_check/b_sysctlvalues

##check multipath##
which multipath 2> /dev/null
if [ $? == 0 ]; then
        multipath -ll |grep failed -B 3 |grep HP |awk '{print $2}' |sed s/"("//g |sed s/")"//g > /usr/local/stats/script_RB_check/b_failed_luns
        multipath -ll |grep HP |awk '{print $2}' |sed s/"("//g |sed s/")"//g > /usr/local/stats/script_RB_check/b_all_luns
        rm -f /usr/local/stats/script_RB_check/b_active_luns
                for lun in `cat /usr/local/stats/script_RB_check/b_all_luns`
                do
                grep $lun /usr/local/stats/script_RB_check/b_failed_luns > /dev/null
                        if [ $? == 0 ]; then
                        echo " " > /dev/null
                        else
                        echo $lun >> /usr/local/stats/script_RB_check/b_active_luns
                        fi
                done
else
echo " " > /dev/null
fi
