#!/bin/sh
# Swatchbeat — Internet Time (@beats) for the shell
# BMT = UTC+1, no DST. 1 beat = 86.4 seconds.

set -eu

usage() {
  cat <<'USAGE'
Swatchbeat — Internet Time (@beats)

Usage:
  swatchbeat.sh                 Print current beat
  swatchbeat.sh --clock HH:MM[:SS]
                                Convert BMT (UTC+1) clock to beat
  swatchbeat.sh --beat N        Convert beat (0–999) to BMT clock
  swatchbeat.sh -h | --help     Show this help

Examples:
  swatchbeat.sh --clock 14:30
  swatchbeat.sh --beat 500
  swatchbeat.sh --beat @500
USAGE
}

# Format beat as @000.00 (two decimals, floored like the web version)
format_beat() {
  # $1 = beat as float string
  awk -v n="$1" 'BEGIN {
    v = int(n * 100) / 100
    s = sprintf("%.2f", v)
    while (length(s) < 6) s = "0" s
    printf "@%s\n", s
  }'
}

pad2() {
  awk -v n="$1" 'BEGIN { printf "%02d", n+0 }'
}

# Current BMT seconds since midnight (float) via UTC+1
current_bmt_sec() {
  # date -u +%s is portable enough with GNU/BSD; use UTC then +3600
  utc_h=$(date -u +%H)
  utc_m=$(date -u +%M)
  utc_s=$(date -u +%S)
  # strip leading zeros for arithmetic in awk
  awk -v h="$utc_h" -v m="$utc_m" -v s="$utc_s" 'BEGIN {
    h += 0; m += 0; s += 0
    # BMT = UTC+1
    h = (h + 1) % 24
    print h*3600 + m*60 + s
  }'
}

clock_to_beat() {
  # $1 = HH:MM or HH:MM:SS
  raw=$1
  echo "$raw" | grep -Eq '^[0-9]{1,2}:[0-9]{2}(:[0-9]{2})?$' || {
    echo "error: use HH:MM or HH:MM:SS (BMT / UTC+1)" >&2
    exit 1
  }
  h=$(echo "$raw" | cut -d: -f1)
  mi=$(echo "$raw" | cut -d: -f2)
  s=$(echo "$raw" | awk -F: '{print (NF>=3)?$3:0}')
  awk -v h="$h" -v m="$mi" -v s="$s" 'BEGIN {
    h+=0; m+=0; s+=0
    if (h>23 || m>59 || s>59) { exit 2 }
    beat = ((h*3600 + m*60 + s) / 86.4)
    # keep in 0..1000
    beat = beat - int(beat/1000)*1000
    if (beat < 0) beat += 1000
    printf "%.10f\n", beat
  }' || {
    echo "error: invalid clock time" >&2
    exit 1
  }
}

beat_to_clock() {
  raw=$(echo "$1" | sed 's/^@//')
  awk -v b="$raw" 'BEGIN {
    if (b !~ /^-?[0-9]*\.?[0-9]+$/) exit 2
    b = b + 0
    # normalize into [0,1000)
    b = b - int(b/1000)*1000
    if (b < 0) b += 1000
    total = b * 86.4
    h = int(total / 3600) % 24
    m = int((total % 3600) / 60)
    s = int(total % 60)
    printf "%02d:%02d:%02d BMT (UTC+1)\n", h, m, s
  }' || {
    echo "error: enter a beat 0–999" >&2
    exit 1
  }
}

cmd_now() {
  sec=$(current_bmt_sec)
  beat=$(awk -v sec="$sec" 'BEGIN { printf "%.10f\n", (sec / 86.4) % 1000 }')
  format_beat "$beat"
}

if [ $# -eq 0 ]; then
  cmd_now
  exit 0
fi

case "$1" in
  -h|--help)
    usage
    ;;
  --clock)
    if [ $# -lt 2 ]; then
      echo "error: --clock needs HH:MM[:SS]" >&2
      exit 1
    fi
    beat=$(clock_to_beat "$2")
    format_beat "$beat"
    ;;
  --beat)
    if [ $# -lt 2 ]; then
      echo "error: --beat needs a number" >&2
      exit 1
    fi
    beat_to_clock "$2"
    ;;
  *)
    echo "error: unknown option: $1" >&2
    usage >&2
    exit 1
    ;;
esac
