#!/bin/bash
#
# has_oracle_java_1.7.sh
#
# Checks to see if Oracle Java 7 is installed.
# Prints Yes if it is, No if it's not.
#

OUTPUT=`java -version 2>&1`
if [[ $OUTPUT == *"build 1.7"* ]] && [[ $OUTPUT == *"HotSpot"* ]]
then
  echo 'Yes'
else
  echo 'No'
fi
