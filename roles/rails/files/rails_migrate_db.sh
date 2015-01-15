#!/bin/bash
#
# rails_migrate.sh
#
# Run Rails migration
#

. ~/.bash_profile
cd ~/aptrust/fluctus
bundle exec rake db:migrate
