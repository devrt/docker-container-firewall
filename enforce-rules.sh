#!/bin/sh

echo "Checking for existing $CHAIN_NAME chain..."
iptables -S $CHAIN_NAME
if [ 0 -ne $? ];
then
    echo "No existing chain. Create new."
    iptables -N $CHAIN_NAME
fi

echo "Flushing and filling rule to only accept port $ACCEPT_PORT to the chain..."
iptables -F $CHAIN_NAME
iptables -A $CHAIN_NAME -m conntrack --ctstate RELATED,ESTABLISHED -j RETURN
iptables -A $CHAIN_NAME -m conntrack --ctstate INVALID -j DROP
IFS=','
for p in $ACCEPT_PORT
do
    iptables -A $CHAIN_NAME -p tcp -m conntrack --ctstate NEW --dport $p -j RETURN
done
iptables -A $CHAIN_NAME -j DROP
# print rule for confirmation
iptables -S $CHAIN_NAME

echo "Checking whether the $CHAIN_NAME chain enforced to the entrance network interface..."
iptables -S DOCKER-USER | grep $CHAIN_NAME
if [ 0 -ne $? ];
then
    EXTDEV=`ip route show | grep default | awk '{print $5;}'`
    echo "Currently not enforced. Enforcing the chain to $EXTDEV interface."
    iptables -I DOCKER-USER -i $EXTDEV -j $CHAIN_NAME
    # print rule for confirmation
    iptables -S DOCKER-USER | grep $CHAIN_NAME
fi

# wait infinitely
tail -f /dev/null