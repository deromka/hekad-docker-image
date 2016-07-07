#!/usr/bin/env bash

echo "---------- Starting Hekad ------------"

# get the arguments
/scripts/use-arguments.sh "$@"

config_path="/scripts/hekad.toml"
# check if config was passed, if so use it instead of generating a new one from template
value=`cat env.properties | grep -w config | sed "s|config=||"`
if [[ -z $value ]]; then
    echo "config is not configured, trying to generate it from template ..."
    # evaluate j2 template
    python /scripts/evaluate-template-file.py hekad.toml.j2 $config_path
    echo "generated config file: $config_path"
else
    echo "using config=$value"
    config_path=$value
fi

echo "config file: $config_path"
cat $config_path
echo "-------------------------"

value=`cat env.properties | grep -w test | sed "s|test=||"`
if [[ -z $value ]]; then
    echo "running hekad"
    /heka/build/heka/bin/hekad --config $config_path
else
    echo "testing config"
    /heka/build/heka/bin/heka-logstreamer --config $config_path
fi

