#!/bin/bash
if [[ ! -z ${debug} ]]; then
  set -x
fi
declare -A services
declare total=0
declare current=0


function spawn() {
  name=$(echo $1 | rev | cut -d / -f 1 | cut -d '.' -f 2- |rev)
  nice $1 2>${name}.err.log 1>${name}.std.log &
  services[${name}]=$!
}

#pid=$(spawn ./service.sh)
#pidname=$(echo $pid | cut -d '+' -f 1)
#pidid=$(echo $pid | cut -d '+' -f 2)

#declare -A services[$pidname]=$pidid
spawn ./service.sh
echo i have ${#services[@]}
echo content: ${services[@]}
echo content: ${!services[@]}
total=$(($total+1))
current=${#services[@]}

while true ; do
  if [[ $total -ne ${current} ]] ; then
    echo something died
    break
  fi
  current=${#services[@]}
  for each in ${services[@]} ; do
    if [[ ! -d "/proc/${each}" ]] ; then
      echo "${each} status ....... not ok"
      current=$(($current-1))
    else
      echo "${each} status ....... ok"
   fi
  done
sleep 1
done
echo done
