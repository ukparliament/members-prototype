#! /usr/bin/env bash

IMAGE=$1
APP_NAME=$2
AWS_REGION=$3
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMPFILE=$(mktemp)
cat $DIR/task-definition.json | sed -e s#\{\{IMAGE\}\}#$IMAGE# -e s#\{\{APP_NAME\}\}#$APP_NAME# -e s#\{\{AWS_REGION\}\}#$AWS_REGION# > $TMPFILE
aws ecs register-task-definition --cli-input-json file://$TMPFILE
rm $TMPFILE
