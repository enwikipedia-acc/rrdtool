#!/bin/bash
STEP=300
HB=600

rrdtool create acc.rrd --start `date +%s` --step $STEP \
DS:open:GAUGE:$HB:0:U \
DS:admin:GAUGE:$HB:0:U \
DS:checkuser:GAUGE:$HB:0:U \
DS:hold:GAUGE:$HB:0:U \
RRA:AVERAGE:0.5:1:288 \
RRA:AVERAGE:0.5:3:672 \
RRA:AVERAGE:0.5:12:744 \
RRA:AVERAGE:0.5:72:1480
