#! /usr/bin/env bash

TMPFILE=$(mktemp)
aws ecs describe-task-definition --task-definition memberserviceapi | jq "{ containerDefinitions: .taskDefinition.containerDefinitions, family: .taskDefinition.family }" > $TMPFILE
aws ecs register-task-definition --cli-input-json file://$TMPFILE
rm $TMPFILE
