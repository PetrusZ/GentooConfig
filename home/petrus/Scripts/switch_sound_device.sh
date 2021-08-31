#!/bin/bash

# PulseAudio clients can send audio to "sinks" and receive audio from "sources".
# So sinks are outputs (audio goes there), sources are inputs (audio comes from there).

current_sink=$(pactl info | grep "Default Sink" | awk '{print $3}')
current_source=$(pactl info | grep "Default Source" | awk '{print $3}')

declare next_sink
declare next_source

function read_sink_source {
    is_current=0
    next_sink=0
    while read line
    do
        # echo $line
        id=$(echo $line | awk '{print $1}')
        name=$(echo $line | awk '{print $2}')

        if [[ $is_current == 1 ]]; then
            next_sink=$name
            break
        fi

        if [[ $name == $current_sink ]]; then
            is_current=1
            # echo $name
        fi
        # echo $next_sink
    done < <(pactl list short sinks)

    if [[ $next_sink == 0 ]]; then
        next_sink=$(pactl list short sinks | awk '{print $2}' | head -n1)
    fi
    # echo $next_sink

    is_current=0
    next_source=0
    while read line
    do
        # echo $line
        id=$(echo $line | awk '{print $1}')
        name=$(echo $line | awk '{print $2}')

        if [[ $is_current == 1 ]]; then
            next_source=$name
            break
        fi

        if [[ $name == $current_source ]]; then
            is_current=1
            # echo $name
        fi
        # echo $next_source
    done < <(pactl list short sources)

    if [[ $next_source == 0 ]]; then
        next_source=$(pactl list short sources | awk '{print $2}' | head -n1)
    fi
    # echo $next_source
}

function switch_sound_device {
    sink_id=$1
    source_id=$2

    pacmd set-default-sink $sink_id
    pacmd set-default-source $source_id

    # 切换目前的playback stream
    pactl list short sink-inputs | while read line
do
    sink_input_id=$(echo $line | awk '{print $1}')
    # echo "sink_input_id $sink_input_id"
    pactl move-sink-input $sink_input_id $sink_id
done

    # 切换目前的recording stream
    pactl list short source-outputs | while read line
do
    source_output_id=$(echo $line | awk '{print $1}')
    # echo "source_output_id $source_output_id"
    pactl move-source-output $source_output_id $source_id
done
}

function echo_icon() {
    if [ $(pactl info | grep "Default Sink" | awk '{print $3}' | grep -i "hdmi") ]; then
        # soundbar
        echo "󰀃"
    elif [ $(pactl info | grep "Default Sink" | awk '{print $3}' | grep -i "analog") ]; then
        # headphone
        echo ""
    elif [ $(pactl info | grep "Default Sink" | awk '{print $3}' | grep -i "bluez") ]; then
        # bluetooth
        echo ""
    fi
}

read_sink_source

if [ $1 ] && [ $1 == 'switch' ]; then
    switch_sound_device $next_sink $next_source
else
    echo_icon
fi
