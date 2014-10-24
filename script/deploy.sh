#!/usr/local/bin/zsh

curl -i -H "Accept: application/json" \
 -H "Content-Type:application/json" \
 -X POST --data '{"name":"showwin", "branch":"production"}' \
 http://deploy.fc2play.com
