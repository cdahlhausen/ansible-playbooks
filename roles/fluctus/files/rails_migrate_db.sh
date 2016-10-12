#!/bin/bash
#
# rails_migrate.sh
#
# Run Rails migration
#

. ~/.profile
cd ~/aptrust/fluctus
bundle exec rake db:migrate
