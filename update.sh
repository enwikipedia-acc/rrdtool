#!/bin/bash

cd "$(dirname "$0")"

wget --no-check-certificate -O status.xml -o /dev/null http://accounts-appserver4.eqiad.wmflabs/api.php?action=status

cat status.xml | sed "s/</\r\n</g" | grep status | sed "s/ /\n/g" | sed "s/\"\/>/\"/" | grep -v "<status" | head -n5 |sed "s/\"//g" > values
rm status.xml
chmod a+x values
. values
rm values


rrdval="N:"
rrdval=$rrdval$open
rrdval=$rrdval":"
rrdval=$rrdval$admin
rrdval=$rrdval":"
rrdval=$rrdval$checkuser
rrdval=$rrdval":"
rrdval=$rrdval$hold
rrdval=$rrdval":"
rrdval=$rrdval$proxy

#echo $rrdval;
rrdtool update acc.rrd $rrdval
