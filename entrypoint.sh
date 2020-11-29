#!/bin/bash

envsubst < ./connect-properties/connect-standalone.properties.template > ./connect-properties/connect-standalone.properties
envsubst < ./connect-properties/source.properties.template > ./connect-properties/source.properties
#envsubst < ./newrelic/newrelic.yml.template > ./newrelic/newrelic.yml

if [[ "$#" -eq 0 ]]
then
    echo "Starting Connect..."
    exec /opt/kafka_2.12-2.6.0/bin/connect-standalone.sh ./connect-properties/connect-standalone.properties ./connect-properties/source.properties 2>&1
else
    /bin/bash -c "$*"
fi
