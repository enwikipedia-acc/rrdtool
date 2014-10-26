#!/bin/bash

cd /home/stwalkerster/rrd/acc-new/

wget --no-check-certificate -O status.xml -o /dev/null https://accounts.wmflabs.org/api.php?action=status

cat status.xml | sed "s/</\r\n</g" | grep status | sed "s/ /\n/g" | sed "s/\"\/>/\"/" | grep -v "<status" | head -n4 |sed "s/\"//g" > values
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

#echo $rrdval;
rrdtool update /home/stwalkerster/rrd/acc-new/acc.rrd $rrdval
