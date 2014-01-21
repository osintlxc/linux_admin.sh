#!/bin/bash
#author vignesh_ragupathy@yahoo.com


service --status-all |grep running... |awk '{print $1}' > /usr/local/stats/script_RB_check/a_services

/etc/init.d/network status |grep active -A 1 |sed -n 2,5p >> /usr/local/stats/script_RB_check/a_services

/etc/init.d/iptables status |grep "Firewall is not running" > /dev/null
        if [ $? != 0 ]; then
        echo iptables >> /usr/local/stats/script_RB_check/a_services
        fi

free -m |grep Mem |awk '{print $2}' > /usr/local/stats/script_RB_check/a_memory


df -Ph |awk '{print $NF}' |sed -n 2,100p > /usr/local/stats/script_RB_check/a_mounted


for Service in `cat /usr/local/stats/script_RB_check/b_services`
do
grep $Service /usr/local/stats/script_RB_check/a_services > /dev/null
        if [ $? == 0 ]; then
        echo 1 > /usr/local/stats/script_RB_check/service_status.txt
        else
        echo $Service not running
        echo 0 > /usr/local/stats/script_RB_check/service_status.txt
        fi
done

grep 1 /usr/local/stats/script_RB_check/service_status.txt > /dev/null
        if [ $? == 0 ]; then
        echo All service runing
        fi

for Volume in `cat /usr/local/stats/script_RB_check/b_mounted`
do
grep $Volume /usr/local/stats/script_RB_check/a_mounted > /dev/null
        if [ $? == 0 ]; then
        echo 1 > /usr/local/stats/script_RB_check/volume_status.txt
        else
        echo $Volume not mounted
        echo 0 > /usr/local/stats/script_RB_check/volume_status.txt
        fi
done

grep 1 /usr/local/stats/script_RB_check/volume_status.txt > /dev/nul
        if [ $? == 0 ]; then
        echo All Volumes mounted
        fi

Memory=`cat /usr/local/stats/script_RB_check/a_memory`
grep $Memory /usr/local/stats/script_RB_check/b_memory > /dev/null
        if [ $? == 0 ]; then
        echo Total Memory is same
        else
        echo Mismatch in Memory
        fi



sysctl -a |grep -v kernel.random.uuid |grep -v random.entropy_avail  |grep -v fs.inode |grep -v fs.dentry-state |perl -lape 's/\s+//sg'  > /usr/local/stats/script_RB_check/a_sysctlvalues
echo " "> /usr/local/stats/script_RB_check/sysctl_status.txt
while read line
do
grep $line /usr/local/stats/script_RB_check/b_sysctlvalues > /dev/null
if [ $? == 0 ]; then
echo 1 >> /usr/local/stats/script_RB_check/sysctl_status.txt
else
echo Kernel parameter mismatch for $line
echo 0 >> /usr/local/stats/script_RB_check/sysctl_status.txt
fi
done <  /usr/local/stats/script_RB_check/a_sysctlvalues

grep 0 /usr/local/stats/script_RB_check/sysctl_status.txt > /dev/nul
        if [ $? != 0 ]; then
        echo Sysctl values are same
        fi




which multipath 2> /dev/null
if [ $? == 0 ]; then
        multipath -ll |grep failed -B 3 |grep HP |awk '{print $2}' |sed s/"("//g |sed s/")"//g > /usr/local/stats/script_RB_check/a_failed_luns
        multipath -ll |grep HP |awk '{print $2}' |sed s/"("//g |sed s/")"//g > /usr/local/stats/script_RB_check/a_all_luns
        rm -f /usr/local/stats/script_RB_check/a_active_luns
                for lun in `cat /usr/local/stats/script_RB_check/b_all_luns`
                do
                grep $lun /usr/local/stats/script_RB_check/a_failed_luns > /dev/null
                        if [ $? == 0 ]; then
                        echo " " > /dev/null
                        else
                        echo $lun >> /usr/local/stats/script_RB_check/a_active_luns
                        fi
                done


        for Lun  in `cat /usr/local/stats/script_RB_check/b_active_luns`
        do
        grep $Lun /usr/local/stats/script_RB_check/a_active_luns > /dev/null
                if [ $? == 0 ]; then
                echo 1 > /usr/local/stats/script_RB_check/active_lun_status.txt
                else
                echo Lun $Lun is missing
                echo 0 > /usr/local/stats/script_RB_check/active_lun_status.txt
                fi
        done

        grep 1 /usr/local/stats/script_RB_check/active_lun_status.txt > /dev/null
                if [ $? == 0 ]; then
                echo All LUNS are active as before reboot
                fi


        for Lun  in `cat /usr/local/stats/script_RB_check/a_active_luns`
        do
        grep $Lun /usr/local/stats/script_RB_check/b_active_luns > /dev/null
                if [ $? == 0 ]; then
                echo " " > /dev/null
                else
                echo New LUN $Lun found
                fi
                done

else
echo " " > /dev/null
fi
