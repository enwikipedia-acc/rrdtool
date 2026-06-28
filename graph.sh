#!/bin/bash

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "${DATA_DIR:-$script_dir}"

defs=(
    DEF:open=acc.rrd:open:AVERAGE
    DEF:admin=acc.rrd:admin:AVERAGE
    DEF:cu=acc.rrd:checkuser:AVERAGE
    DEF:hold=acc.rrd:hold:AVERAGE
    DEF:proxy=acc.rrd:proxy:AVERAGE
)

time_slugs=(day 2day 4day week 2week month 3month 6month year 2year 3year 4year 5year)
time_dates=(-1day -2day -4day -1week -2week -1month -3month -6month -1year -2year -3year -4year -5year)
time_titles=("day" "2 days" "4 days" "week" "2 weeks" "month" "3 months" "6 months" "year" "2year" "3year" "4year" "5year")

acc_lines=(
    "LINE2:open#FF0000:Open requests"
    "LINE2:admin#FF8800:Flagged user requests"
    "LINE2:cu#00FF00:Checkuser requests"
    "LINE2:hold#0000FF:Held requests"
    "LINE2:proxy#FF00FF:Proxy check"
    HRULE:25#000000
)

acc_stack_lines=(
    "AREA:open#FF0000:Open requests:STACK"
    "AREA:admin#FF8800:Flagged user requests:STACK"
    "AREA:cu#00FF00:Checkuser requests:STACK"
    "AREA:hold#0000FF:Held requests:STACK"
    "AREA:proxy#FF00FF:Proxy check"
)

generate() {
    local dir="$1" graph="$2" start="$3" end="$4" title="$5"
    shift 5
    rrdtool graph "$dir/$graph.png"            -w 800  -h 300 -s "$start" -e "$end" --title "$title" "$@"
    rrdtool graph "$dir/$graph.svg"       -a SVG -w 800  -h 300 -s "$start" -e "$end" --title "$title" "$@"
    rrdtool graph "$dir/$graph-large.png"       -w 1500 -h 650 -s "$start" -e "$end" --title "$title" "$@"
    rrdtool graph "$dir/$graph-large.svg" -a SVG -w 1500 -h 650 -s "$start" -e "$end" --title "$title" "$@"
}

outdir="${OUTPUT_PREFIX:-.}"
mkdir -p "$outdir"
cp "$script_dir/index.html" "$outdir/index.html"

for i in "${!time_slugs[@]}"; do
    slug="${OUTPUT_PREFIX:-}${time_slugs[$i]}"
    date_arg="${time_dates[$i]}"
    title="${time_titles[$i]}"

    mkdir -p "$slug"
    start=$(date -d "$date_arg" +%s)
    end=$(date +%s)

    generate "$slug" acc       "$start" "$end" "ACC requests (last $title)" "${defs[@]}" "${acc_lines[@]}"
    generate "$slug" acc-stack "$start" "$end" "ACC requests (last $title)" "${defs[@]}" "${acc_stack_lines[@]}"

    cat > "$slug/index.html" << HTMLEOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>ACC Request Graphs — last $title</title>
</head>
<body>
  <h1>ACC Request Graphs</h1>
  <p><a href="../">← All time periods</a></p>
  <h2>Last $title</h2>
  <h3>Line graph</h3>
  <p><a href="acc.png"><img src="acc.png" alt="Line graph — last $title" width="800" height="300"></a></p>
  <p><a href="acc.svg">SVG</a> · <a href="acc-large.png">Large PNG</a> · <a href="acc-large.svg">Large SVG</a></p>
  <h3>Stacked area graph</h3>
  <p><a href="acc-stack.png"><img src="acc-stack.png" alt="Stacked area graph — last $title" width="800" height="300"></a></p>
  <p><a href="acc-stack.svg">SVG</a> · <a href="acc-stack-large.png">Large PNG</a> · <a href="acc-stack-large.svg">Large SVG</a></p>
  <hr>
  <p>Source code: <a href="https://github.com/enwikipedia-acc/rrdtool/">https://github.com/enwikipedia-acc/rrdtool/</a></p>
</body>
</html>
HTMLEOF
done
