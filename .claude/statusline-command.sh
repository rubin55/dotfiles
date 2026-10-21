#!/bin/bash
# Status line: model | dir | branch | context | cost | rate limits
input=$(cat)
j() { echo "$input" | jq -r "$1 // empty"; }
k() { awk -v n="$1" 'BEGIN { printf "%.0fk", n / 1000 }'; }

model=$(j .model.display_name)
dir=$(j '.workspace.current_dir // .cwd')
size=$(j .context_window.context_window_size)
pct=$(j .context_window.used_percentage)
used=$(awk -v p="${pct:-0}" -v s="${size:-0}" 'BEGIN { print p * s / 100 }')
cost=$(j .cost.total_cost_usd)
five=$(j .rate_limits.five_hour.used_percentage)
week=$(j .rate_limits.seven_day.used_percentage)

parts=()
[ -n "$model" ] && parts+=("$model")
if [ -n "$dir" ]; then
  parts+=("$(basename "$dir")")
  branch=$(git --no-optional-locks -C "$dir" symbolic-ref --short HEAD 2>/dev/null \
    || git --no-optional-locks -C "$dir" rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && parts+=("$branch")
fi
[ -n "$size" ] && parts+=("$(printf 'ctx %s/%s (%.0f%%)' "$(k "$used")" "$(k "$size")" "${pct:-0}")")
[ -n "$cost" ] && parts+=("$(printf '$%.2f' "$cost")")
rl=""
[ -n "$five" ] && rl="5h:$(printf '%.0f' "$five")%"
[ -n "$week" ] && rl="${rl:+$rl }7d:$(printf '%.0f' "$week")%"
[ -n "$rl" ] && parts+=("$rl")

out=""
for p in "${parts[@]}"; do out="${out:+$out | }$p"; done
printf '%s' "$out"
