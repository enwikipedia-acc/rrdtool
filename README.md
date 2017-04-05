To add a new datasource (DS):

* Check the new type is being reported on the API directly after the existing ones

* Either suspend cron, or do all of this in the next five minutes

* Pull the creation statement out of create.sh
* Add a `--source acc.rrd` parameter to it, and change the acc.rrd filename to acc-new.rrd so we don't clobber the existing file
* Run it, making sure to use a 1.5+ version of rrdtool (jessie is 1.4.8, accounts-appserver4 has a 1.6.0 locally installed in /opt)
* Run `rrdtool info acc-new.rrd` to ensure the new DS has been created successfully
* Move the files around so the new RRDB is in place of the old one
* Change head -n5 to head -n6 in update.sh (or whatever values necessary - this is the count of attributes from the XML to use.
* Add the new field named by the XML attribute name to the update statement - copy/pasta

* Re-enable cron, or restart the flow of time

* Edit graph.php to draw the new DS onto the graphs. You need to change $defs at the top, and the $graphs array near the bottom

...and that should be you done. Keep an eye on the graphs over the next half-hour or so
