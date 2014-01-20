#!/bin/sh
# Author vignesh_ragupathy@yahoo.com
#Changes - Modified to delete even when the filename contains spaces

###set the directoy affected with exe file
directory=/home/vignesh/staging
echo " " > $directory/exe_delete.log

find $directory/* -type d | while read dir
do
    name="${dir##*/}"
    if [ -e "$dir/$name.exe" ]; then
### removing the exe files having the same name as parent direcrory
        echo "Removing "$dir/$name.exe"" >> $directory/exe_delete.log
echo "$dir/$name.exe" |while read file; do rm -f "$file" ; done
    fi
done
