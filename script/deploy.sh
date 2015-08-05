#!/bin/bash
FILENAME='deploy/cold'

if [ -f "${FILENAME}" ]; then
  echo "----- bundle exec cap production deploy:stop ----- "
  bundle exec cap production deploy:stop
  echo "----- bundle exec cap production deploy BRANCH=master ----- "
  bundle exec cap production deploy BRANCH=master
else
  echo "----- bundle exec cap production deploy BRANCH=master ----- "
  bundle exec cap production deploy BRANCH=master
fi
