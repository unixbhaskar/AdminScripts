#!/bin/bash 

# An attempt to automatize packaging DokuWiki  
HOSTNAME=$(uname -n)
DATE=$(date)
echo " Dokulwiki installation on $HOSTNAME and on this $DATE" 
echo
echo
echo
sleep 5
  RELEASE_FILE="dokuwiki-5422200921b877a379e34cc4e0fee22a.tgz"
#  NEWNAME=$(echo "$RELEASE" | tr '-' '.')
  WORKDIR="/home/bhaskar/dokuwiki"
# NO_OF_COMP=5
  WWWDIR="/var/www/"
  

echo " Creating a symlink from $WORKDIR to web serving dir $WWWDIR "

/bin/ln -sv $WORKDIR $WWWDIR

echo "Cross checking the link...."

/usr/bin/namei $WWWDIR/*

#Cross checking webserver presence

#apache2 --version | head -n1
  
#  mkdir -p "$WORKDIR/dokuwiki/etc/apache2/conf.d"
#  mkdir -p "$WWWDIR"
   
    # assume the standard download location
    DLFROM="http://download.dokuwiki.org/out/dokuwiki-5422200921b877a379e34cc4e0fee22a.tgz"
#    DLFILE="dokuwiki-${RELEASE}.tgz"
    # and get the file
  echo " Get into the app dir ...."
  cd $WORKDIR
  echo
echo "Make sure we are in correct dir ..."

sleep 5
    wget -c ${DLFROM} 
    
     # unpack it
     echo "getting into the web space"
     cd "$WORKDIR" || exit 17
     echo "extracting the file..."
     tar -xvzf "${RELEASE_FILE}"
     sleep 5
     echo " remove the source..."
     rm ${RELEASE_FILE}

  # move it into the right place, create config dirs
  #    echo " Moving it into the right place"
 #     mv ${RELEASE_FILE} dokuwiki
   echo "Giving it a right permission .."

sudo chown -R www-data:www-data /var/www/dokuwiki

ls -al /var/www/dokuwiki


      HTACCESSLIST=$(find "${WWWDIR}/dokuwiki" -name '\.htacc*')
      cd "$WORKDIR" || exit 18
 #     echo " creating an symbolic link for that dir"
   #   ln -s ../srv/www/htdocs/dokuwiki/conf DokuWiki
      
    # write config for Apache
    # delete .htaccess, move it into Apache's conf
     #  echo " delete htaccess file and move it to apache conf"
      # cat <<EOT "/etc/apache2/conf-enabled/DokuWiki.conf" 
      # Alias /dokuwiki "/var/www/dokuwiki"
       
 #<Directory "/var/www/dokuwiki">
  #   Options None
  #       <IfModule mod_dir.c>
   #      DirectoryIndex doku.php index.html index.htm
   #  </IfModule>
   #      AllowOverride All
   #  Order allow,deny
   #      Allow from all
 #</Directory>

 #EOT

echo "Done"

echo $?
# for SUBDIR in $HTACCESSLIST; do
# RELDIR=${SUBDIR#${WORKDIR}/dokuwiki}
# RELDIR=${RELDIR%/.htacc*}
# echo "«Directory \"$RELDIR\"»" »» 'apache2/conf.d/DokuWiki.conf'
# cat "$SUBDIR" »» 'apache2/conf.d/DokuWiki.conf'
# echo "«/Directory»" »» 'apache2/conf.d/DokuWiki.conf'
# echo " " »» 'apache2/conf.d/DokuWiki.conf'
# rm "$SUBDIR"
# done
# dos2unix -o 'apache2/conf.d/DokuWiki.conf'
#
#
# cd "$WORKDIR" || exit 19
# tar --strip-components=$NO_OF_COMP -cf "dokuwiki-${NEWNAME}.tar" dokuwiki
# gzip "dokuwiki-${NEWNAME}.tar"
