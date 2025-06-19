#!/bin/bash

rm /tmp/desktop_audio_temp.mp3

cleanup() {
    echo "Recording stopped. Cleaning up..."
    kill $FFMPEG_PID
    echo "file:///tmp/desktop_audio_temp.mp3" | xclip -sel c
    gxmessage -geometry 350x50 -title "audio recorded" -center "desktop dudio has been copied to your clipboard."
    exit 0
}

trap cleanup SIGINT SIGTERM

ffmpeg -f pulse -i alsa_output.usb-FX-AUDIO-_DAC-X3PRO_20313330544D4319001C8004-00.analog-stereo.monitor /tmp/desktop_audio_temp.mp3 &

FFMPEG_PID=$!
xev | grep -q "keycode: 9" && cleanup

wait $FFMPEG_PID
