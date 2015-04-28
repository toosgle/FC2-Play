#!/usr/local/bin/zsh

curl -i -H "Accept: application/json" \
 -H "Content-Type:application/json" \
 -X POST --data '{"name":"showwin", "branch":"master"}' \
 http://deploy.fc2play.com
echo 'throwing Webhook...'
