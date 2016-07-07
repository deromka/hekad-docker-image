#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Using environment parameters: \n"
    env >> env.properties
else
    echo "Using input arguments: \n"
    while (( "$#" )); do
        case $1 in
            # if string starts with '--', remove it
            --*=*)
                echo $1 | sed 's/--//' >> env.properties
                shift;;
            *)
                echo $1 >> env.properties
                shift;;
        esac
    done
fi
touch env.properties
cat env.properties