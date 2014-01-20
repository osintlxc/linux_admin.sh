#!/bin/bash
### Author vignesh_ragupathy@yahoo.com

for folder in `cat /home/Archive/script/path.txt`
  do
    find $folder -type f -mtime +75 -exec gzip {} \;
        if [ $? -eq 0 ]; then
        echo "`date` successfully archived the files at $folder " >> /home/Archive/script/output.txt
        else
        echo "`date` Couldn't  archived the files at $folder " >> /home/Archive/script/output.txt
        fi
    echo "Total number of files archived is `find $folder -type f -mtime +60 |grep ".gz" |wc -l` " >> /home/Archive/script/output.txt
  done
