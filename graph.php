#!/usr/bin/php
<?php

chdir( __DIR__ );

$defs = "DEF:open=acc.rrd:open:AVERAGE DEF:admin=acc.rrd:admin:AVERAGE DEF:cu=acc.rrd:checkuser:AVERAGE DEF:hold=acc.rrd:hold:AVERAGE DEF:proxy=acc.rrd:proxy:AVERAGE";

$times = array(
	"day" => array(
		"date" => "-1day",
		"title" => "day",
	),
	"2day" => array(
		"date" => "-2day",
		"title" => "2 days",
	),
	"4day" => array(
		"date" => "-4day",
		"title" => "4 days",
	),
	"week" => array(
		"date" => "-1week",
		"title" => "week",
	),
	"2week" => array(
		"date" => "-2week",
		"title" => "2 weeks",
	),
	"month" => array(
		"date" => "-1month",
		"title" => "month",
	),
	"3month" => array(
		"date" => "-3month",
		"title" => "3 months",
	),
	"6month" => array(
		"date" => "-6month",
		"title" => "6 months",
	),
	"year" => array(
		"date" => "-1year",
		"title" => "year",
	),
	"2year" => array(
		"date" => "-2year",
		"title" => "2year",
	),
);

$graphs = array(
	"acc" => '"LINE2:open#FF0000:Open requests" "LINE2:admin#FF8800:Flagged user requests" "LINE2:cu#00FF00:Checkuser requests" "LINE2:hold#0000FF:Held requests" "LINE2:proxy#FF00FF:Proxy check" HRULE:25#000000', // HRULE:235#000000 HRULE:215#000000 HRULE:200#008800 HRULE:50#FF0000',
	"acc-stack" => '"AREA:open#FF0000:Open requests:STACK" "AREA:admin#FF8800:Flagged user requests:STACK" "AREA:cu#00FF00:Checkuser requests:STACK" "AREA:hold#0000FF:Held requests:STACK" "AREA:proxy#FF00FF:Proxy check"',
);

foreach( $times as $slug => $tdata ) {
	@mkdir($slug,0777,true);

	$date = $tdata["date"];
	$title = $tdata["title"];

	foreach( $graphs as $graph => $lines ) {
		exec( "/opt/rrdtool/bin/rrdtool graph $slug/$graph.png -w 800 -h 300 -s `date -d $date +%s` -e `date +%s` --title 'ACC requests (last $title)' $defs $lines" );
		exec( "/opt/rrdtool/bin/rrdtool graph $slug/$graph.svg -a SVG -w 800 -h 300 -s `date -d $date +%s` -e `date +%s` --title 'ACC requests (last $title)' $defs $lines" );
		exec( "/opt/rrdtool/bin/rrdtool graph $slug/$graph-large.png -w 1500 -h 650 -s `date -d $date +%s` -e `date +%s` --title 'ACC requests (last $title)' $defs $lines" );
		exec( "/opt/rrdtool/bin/rrdtool graph $slug/$graph-large.svg -a SVG -w 1500 -h 650 -s `date -d $date +%s` -e `date +%s` --title 'ACC requests (last $title)' $defs $lines" );
	}
}
