#!/bin/bash

echo ""
echo "  DNSSEC root zone verification"
echo ""

## The location where the root trusted key will go
roottrustedkey="/var/named/etc/root_trusted_key"

## change to /tmp and clean up old files
cd /tmp
rm -rf root-*

## retrieve the root zone DNSKEY 
echo "retrieve the root zone DNSKEY using DNS  (root-ds)"
dig +noall +answer DNSKEY . > root-dnskey
dnssec-dsfromkey -f root-dnskey . > root-ds

## retrieve the IANA key digest
echo "retrieve the IANA key digest using https (root-anchors)"
wget -q --no-check-certificate https://data.iana.org/root-anchors/root-anchors.xml

## clean up the digest so we can clearly see the output
rootds=`cat root-ds | grep "8 2" | awk '{print $7 $8}'`
rootanchors=`cat root-anchors.xml | grep \<Digest\> | sed 's/<Digest>//' |sed 's/<\/Digest>//'`

## Print both digests for the user to view
echo " "
echo "Visually compare the digests"
echo -n " root-ds     : "; echo $rootds
echo -n " root-anchors: "; echo $rootanchors
echo " "

## verify that the "root zone DNSKEY" and the "IANA Digest" match
if [ $rootds = $rootanchors ]
 then
   echo " VERIFIED: Good Signature. Digests match."

## collect the verified DNSKEY
    keytype=`cat root-dnskey | grep 257 | awk '{print $5" "$6" "$7 }'`
    trustedkey=`cat root-dnskey | grep 257 | awk '{print substr($0, index($0,$8)) }'`
 ## put the DNSKEY in the format needed by named.conf include file
echo "managed-keys {" > $roottrustedkey
echo "   \".\" initial-key $keytype \"$trustedkey \";" >> $roottrustedkey
echo "};" >> $roottrustedkey
echo " "
echo "done. The key is in $roottrustedkey"
else 
echo " FAILED: BAD Signature. NO MATCH !!"
exit
 fi

