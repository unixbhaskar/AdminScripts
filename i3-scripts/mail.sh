USER="your email here"
PASS="your password here"
  
COUNT=`curl -su $USER:$PASS https://mail.google.com/mail/feed/atom || echo "<fullcount>Not fetching mail</fullcount>"`
COUNT=`echo "$COUNT" | grep -oPm1 "(?<=<fullcount>)[^<]+" `
echo $COUNT
if [ "$COUNT" != "0" ]; then
   if [ "$COUNT" = "1" ];then
      WORD="mail";
   else
      WORD="mails";
   fi
fi

if [[ $COUNT -gt 10 ]];then 

	/usr/bin/notify-send --expire-time=5000 --urgency=normal "You have got mails" 
fi	

