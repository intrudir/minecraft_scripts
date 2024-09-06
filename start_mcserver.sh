#!/bin/bash

# start tmux session
tmux new-session -d -s mc
sleep 1

# Split the pane first
tmux split-window -t mc
sleep 1

# Pane 1: Start htop
tmux send-keys -t mc.1 "htop" C-m
sleep 5

# Pane 0: Start the Minecraft server
tmux send-keys -t mc.0 "cd /home/intrudir/.minecraft && /home/intrudir/.minecraft/start.sh" C-m
sleep 5

# Create a new window (tab) for monitoring the logs
tmux new-window -t mc
sleep 1

# Window 1: Monitor the server logs for player connections
tmux send-keys -t mc:1 "/opt/tools/minecraft_scripts/log_webhook.sh" C-m
sleep 1

# Attach to the tmux session
tmux attach -t mc
sleep 1
tmux select-window -t mc:0
sleep 1

