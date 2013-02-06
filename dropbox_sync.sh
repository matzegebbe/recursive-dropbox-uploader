#/bin/bash
#
# recursive Dropbox Uploader
#
# Copyright (C) 2013 Mathias Gebbe <mathias.gebbe@gmail.com> 
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#




#UPLOADER=/opt/Dropbox-Uploader/dropbox_uploader.sh
UPLOADER=./dropbox_uploader.sh

IFS=$'\012'

function get_files() {

  FILES=`$UPLOADER list "$1" | grep "\[F] " | sed -e 's/^ \[F\] //' 2>&1`

   for i in $FILES

      do

      mkdir -p "$TARGET_DIR$1"
      $UPLOADER download "$1/$i" "$TARGET_DIR$1/$i"
      done

}


function down_dir() {

DIRS=`$UPLOADER list $1 | grep "\[D] " | sed -e 's/^ \[D\] //' 2>&1`

     get_files "$1"

for j in $DIRS

do
   echo "dir: $1/$j"

   down_dir "$1/$j"


done


}


if [ -z $1 ] 
	then
	echo ''
	echo 'recursive download for Dropbox Uploader -- downloads all subdirectories and files in your local folder'
	echo 'This is a fork of "andreafabrizi Dropbox-Uploader". It allows to download hole directories and not only specified files.'
	echo '
	echo 'set the var UPLOADER in this skript or put it in the same directory as your dropbox_uploader.sh script!'
	echo 'usage: ./dropbox_sync.sh /FOLDER_IN_DROPBOX/SUB_FOLDER_IN_DROPBOX/ /PATH/TO/LOCAL/FOLDER'
	echo 'usage: ./dropbox_sync.sh / /PATH/TO/LOCAL/FOLDER'
	echo 'example: ./dropbox_sync.sh /work/study /mnt/sda1/dropbox'
	echo ''
	echo 'https://github.com/matzegebbe/recursive-dropbox-uploader'
else 
	TARGET_DIR=$2
	down_dir $1

fi
