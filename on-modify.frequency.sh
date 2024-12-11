#!/bin/bash

read TASK
read UPDATED_TASK

# Gestion de undo
if [[ "${UPDATED_TASK}" == "{}" ]]; then
    echo "${TASK}"
    exit 0
fi

STATUS=$(echo "${UPDATED_TASK}" | jq -r '.status')
TARGET="completed"

if [[ "${STATUS}" != "${TARGET}" ]]; then
    echo "${UPDATED_TASK}"
    exit 0
fi

FREQUENCY=$(echo "${UPDATED_TASK}" | jq -r '.frequency')
if [[ "${FREQUENCY}" == "null" ]]; then
    echo "${UPDATED_TASK}"
    exit 0
fi

TODAY=$(date '+%F')

NEXT=$(date -d "${TODAY} + ${FREQUENCY}" "+%F")

NEW_TASK=$(echo "${UPDATED_TASK}" | jq -c --arg value "${NEXT}T23:59:59" '.due = $value' | jq -c --arg value "pending" '.status = $value')

echo "${NEW_TASK:-$UPDATED_TASK}"
exit 0
