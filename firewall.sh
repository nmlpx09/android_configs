#!/bin/sh

PREFIX=/system/bin/
GOOGLE_URL=https://www.gstatic.com/ipranges/goog.json
AWS_URL=https://ip-ranges.amazonaws.com/ip-ranges.json

echo "#iptables rules"


echo "#report.appmetrica.yandex.net"

echo "${PREFIX}iptables -A OUTPUT -d 213.180.193.226 -j DROP"


echo "#verizon"

echo "${PREFIX}iptables -A OUTPUT -d 74.6.0.0/16 -j DROP"


cmd package list users > /dev/null

if [ $? -eq 0 ]
then
    echo "#packages"

    UIDS=`cmd package list packages -s -U | cut -d ':' -f3 | sort -n | uniq`

    for uid in $UIDS
    do
        echo "${PREFIX}iptables -I OUTPUT 1 -m owner --uid-owner $uid -j DROP"
    done
fi


echo "#googles"

CIDRS=`curl -s $GOOGLE_URL | grep ipv4Prefix | cut -d ':' -f2 | tr -d '"'`

for cidr in $CIDRS
do
    echo "${PREFIX}iptables -A OUTPUT -d $cidr -j DROP"
done


echo "#aws"

CIDRS=`curl -s $AWS_URL | grep ip_prefix | cut -d ':' -f2 | tr -d '",'`

for cidr in $CIDRS
do
    echo "${PREFIX}iptables -A OUTPUT -d $cidr -j DROP"
done


echo "#iptables rules end"
