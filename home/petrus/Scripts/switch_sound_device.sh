#!/bin/bash

# PulseAudio clients can send audio to "sinks" and receive audio from "sources".
# So sinks are outputs (audio goes there), sources are inputs (audio comes from there).

current_sink=$(pactl info | grep "Default Sink" | awk '{print $3}')
current_source=$(pactl info | grep "Default Source" | awk '{print $3}')
is_soundbar=$(pactl info | grep "Default Sink" | awk '{print $3}' | grep -i SoundBar)

headphone_sink_id=$(pactl list short sinks | grep -vi SoundBar | awk '{print $1}')
soundbar_sink_id=$(pactl list short sinks | grep -i SoundBar | awk '{print $1}')
headphone_source_id=$(pactl list short sources | grep -vi SoundBar | awk '{print $1}')
soundbar_source_id=$(pactl list short sources | grep -i SoundBar | grep -i output | awk '{print $1}')

# echo "current_sink: $current_sink"
# echo "is_soundbar: $is_soundbar"
# echo "headphone_sink_id: $headphone_sink_id"
# echo "headphone_source_id: $headphone_source_id"
# echo "soundbar_sink_id: $soundbar_sink_id"
# echo "soundbar_source_id: $soundbar_source_id"

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

if [ $1 ] && [ $1 == 'switch' ]; then
    if [ $is_soundbar ]; then
        # 目前为默认SoundBar，设置耳机为默认sink
        switch_sound_device $headphone_sink_id $headphone_source_id
    else
        # 目前为默认耳机，设置soundbar为默认sink
        switch_sound_device $soundbar_sink_id $soundbar_source_id
    fi
else
    if [ $is_soundbar ]; then
        # soundbar
       echo "󰀃"
   else
       # headphone
       echo ""
    fi
fi
