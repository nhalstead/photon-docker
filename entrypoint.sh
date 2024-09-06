#!/bin/bash

EXTRACT_COUNTRY="all"
USER_AGENT="docker: tonsnoei/photon-geocoder"

# Download elasticsearch index
if [ ! -d "/photon/photon_data/elasticsearch" ]; then
    echo "Downloading search index"

    if [ "$EXTRACT_COUNTRY" == "all" ]; then
        # Download all countries
        wget --user-agent="$USER_AGENT" -O - http://download1.graphhopper.com/public/photon-db-latest.tar.bz2 | bzip2 -cd | tar x
    else
        # Download specific country
        wget --user-agent="$USER_AGENT" -O - http://download1.graphhopper.com/public/extracts/by-country-code/$EXTRACT_COUNTRY/photon-db-$EXTRACT_COUNTRY-latest.tar.bz2 | bzip2 -cd | tar x
    fi
fi

# Start photon if elastic index exists
if [ -d "/photon/photon_data/elasticsearch" ]; then
    echo "Start photon"
    java -jar photon.jar $@
else
    echo "Could not start photon, the search index could not be found"
fi
