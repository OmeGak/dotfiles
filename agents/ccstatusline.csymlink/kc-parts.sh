#!/usr/bin/env bash
# kc-parts.sh — helper for ccstatusline's custom-command widget.
#
# Invoked as: kc-parts.sh <ctx|cost|rate|cwd|effort>, with Claude Code's status-line
# JSON piped in on stdin. Prints ONE colored fragment (truecolor ANSI,
# reset at the end, no trailing newline) reproducing the coloring logic
# of the original all-in-one statusline.sh, split per ccstatusline widget.

set -euo pipefail

mode="${1:-}"

RST='\033[0m'
# Named colors as ccstatusline renders them at colorLevel 3 (truecolor), so
# fragments match the built-in widgets exactly.
GRAY='\033[38;2;85;87;83m'            # brightBlack
GREEN='\033[38;2;78;154;6m'           # green
YELLOW='\033[38;2;196;160;0m'         # yellow
RED='\033[38;2;204;0;0m'              # red
BRIGHT_MAGENTA='\033[38;2;173;127;168m' # brightMagenta

command -v jq &>/dev/null || { printf '?'; exit 0; }

case "$mode" in
  ctx|cost|rate|cwd|effort) ;;
  *) exit 0 ;;
esac

input=$(cat)

parsed=$(echo "$input" | jq -r '
  (.model.display_name // ""),
  (.context_window.used_percentage // 0 | tostring),
  (.context_window.context_window_size // 0 | tostring),
  (.cost.total_cost_usd // 0 | tostring),
  (.rate_limits.five_hour.used_percentage // -1 | tostring),
  (.rate_limits.seven_day.used_percentage // -1 | tostring),
  (.workspace.current_dir // .cwd // "." | split("/") | last),
  (.effort.level // ""),
  "END"
' 2>/dev/null) || exit 0

{
  IFS= read -r model_name
  IFS= read -r ctx_pct
  IFS= read -r ctx_size
  IFS= read -r cost
  IFS= read -r rate5h
  IFS= read -r rate7d
  IFS= read -r cwd_base
  IFS= read -r effort_level
  IFS= read -r _sentinel
} <<< "$parsed"

model="${model_name:-─}"

if [[ "$mode" == "ctx" ]]; then
  pct_int=${ctx_pct%.*}
  pct_int=${pct_int:-0}
  if (( pct_int < 0 )); then pct_int=0; fi
  if (( pct_int > 100 )); then pct_int=100; fi

  bar_filled=$(( pct_int / 10 ))
  if (( bar_filled > 10 )); then bar_filled=10; fi

  GRAD_R=(46 116 186 241 239 236 233 231 211 192)
  GRAD_G=(204 195 186 196 161 126 101 76 66 57)
  GRAD_B=(113 89 64 15 24 34 44 60 50 43)

  bar=""
  for (( i=0; i<10; i++ )); do
    if (( i < bar_filled )); then
      bar+="\\033[38;2;${GRAD_R[$i]};${GRAD_G[$i]};${GRAD_B[$i]}m█"
    else
      bar+="\\033[38;2;60;60;60m░"
    fi
  done
  bar+="${RST}"

  if (( pct_int >= 90 )); then pct_color="$RED"
  elif (( pct_int >= 70 )); then pct_color="$YELLOW"
  else pct_color="$GREEN"; fi

  ctx_warn=""
  if (( pct_int >= 90 )); then ctx_warn="${RED} ⚠${RST}"; fi

  ctx_size_int=${ctx_size:-0}
  ctx_label=""
  if [[ "$model" != *context* && "$model" != *Context* ]]; then
    if (( ctx_size_int >= 1000000 )); then ctx_label=" ${GRAY}1M${RST}"
    elif (( ctx_size_int >= 200000 )); then ctx_label=" ${GRAY}200k${RST}"
    fi
  fi

  printf '%b' "${bar} ${pct_color}${pct_int}%${RST}${ctx_warn}${ctx_label}"

elif [[ "$mode" == "cost" ]]; then
  cost_val="${cost:-0}"
  cost_fmt=$(printf '%.2f' "$cost_val" 2>/dev/null || echo "0.00")
  cost_int=${cost_val%.*}
  cost_int=${cost_int:-0}

  if (( cost_int >= 10 )); then cost_color="$RED"
  elif (( cost_int >= 5 )); then cost_color="$YELLOW"
  elif [[ "$cost_fmt" == "0.00" ]]; then cost_color="$GRAY"
  else cost_color="$YELLOW"; fi

  printf '%b' "${cost_color}\$${cost_fmt}${RST}"

elif [[ "$mode" == "rate" ]]; then
  rate5h_int=${rate5h%.*}; rate5h_int=${rate5h_int:-0}
  rate7d_int=${rate7d%.*}; rate7d_int=${rate7d_int:-0}

  rate_parts=""
  if (( rate5h_int >= 0 )); then
    if (( rate5h_int >= 80 )); then rate_parts+="${RED}5h:${rate5h_int}%${RST}"
    else rate_parts+="${GRAY}5h:${rate5h_int}%${RST}"; fi
  fi
  if (( rate7d_int >= 0 )); then
    if [[ -n "$rate_parts" ]]; then rate_parts+=" "; fi
    if (( rate7d_int >= 80 )); then rate_parts+="${RED}7d:${rate7d_int}%${RST}"
    else rate_parts+="${GRAY}7d:${rate7d_int}%${RST}"; fi
  fi

  printf '%b' "$rate_parts"

elif [[ "$mode" == "cwd" ]]; then
  printf '%s' "${cwd_base}"

elif [[ "$mode" == "effort" ]]; then
  if [[ -z "$effort_level" ]]; then
    effort_level=$(jq -r '.effortLevel // ""' "$HOME/.claude/settings.json" 2>/dev/null || true)
  fi
  if [[ -z "$effort_level" ]]; then
    effort_level="default"
  fi

  case "$effort_level" in
    low) effort_color="$GRAY" ;;
    medium) effort_color="$GREEN" ;;
    high) effort_color="$BRIGHT_MAGENTA" ;;
    xhigh) effort_color="$YELLOW" ;;
    max) effort_color="$RED" ;;
    default) effort_color="$GRAY" ;;
    *) effort_color="$GRAY"; effort_level="${effort_level}?" ;;
  esac

  printf '%b' "${effort_color}${effort_level}${RST}"
fi
