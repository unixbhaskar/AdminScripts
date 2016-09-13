 P=1; 
for i in $(seq -w 200); do echo "192.168.99.$P n$i"; P=$(expr $P + 1);
done >>/home/bhaskar/hosts
