#!/bin/bash

# get env vars
source .env

# Function to send a webhook when a player joins
send_webhook() {
    if [[ "$1" == "join" ]]; then
        message="$2 - Player $3 has joined the server"
    elif [[ "$1" == "leave" ]]; then
        message="$2 - Player $3 has left the server"
    fi
    
    curl -X POST -H "Content-Type: application/json" -d "{\"content\": \"$message\"}" "$webhook_url"
}

# Monitor the server log for player connections in the background
tail -F -n 1 /home/intrudir/.minecraft/logs/latest.log | while read line; do
    if [[ "$line" == *"joined the game"* ]]; then
        log_time=$(echo $line | awk '{print $2}' | tr -d ']')
        player=$(echo $line | awk '{print $6}')

        #player=$(echo $line)
        send_webhook "join" "$log_time" "$player"

    elif [[ "$line" == *"left the game"* ]]; then
        log_time=$(echo $line | awk '{print $2}' | tr -d ']')
        player=$(echo $line | awk '{print $6}')

        send_webhook "leave" "$log_time" "$player"
    fi
done

