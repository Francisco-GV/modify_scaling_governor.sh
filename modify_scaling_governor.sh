#!/bin/bash

# save available governors in a variable
scaling_available_governors=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors) #| sed 's/ *$//g')

RED="\e[31m"
GREEN="\e[32m"
CLEAR="\e[0m"

echo -e "scaling_available_governors content:\n\"${scaling_available_governors}\""

if [ -z "$1" ]; then
    echo -e "${RED}Argument required.${CLEAR}"
    exit 1
fi

selected=$1

# convert variable in array 'governors'
readarray -d ' ' -t governors <<< ${scaling_available_governors}

contains=false

echo -e "${GREEN}#######################################${CLEAR}"
#echo "number of governors: ${#governors[@]}"
#declare -p governors
#echo -e "${GREEN}#######################################${CLEAR}"
for i in "${governors[@]}"
do
    if [[ $i == $selected ]]; then
        contains=true
    fi
done

if [ $contains = true ]; then
    echo "Setting $selected mode..."
else
    echo "$selected not found, exiting..."
    exit 1
fi

echo $selected | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
