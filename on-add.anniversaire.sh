#!/bin/bash

# Récupération de la tâche
read TASK

# Condition
PROJECT=$(echo "${TASK}" | jq -r '.project')
TARGET="Social.Anniversaire"

# Si ce n'est pas un anniversaire
if [[ "${PROJECT}" != "${TARGET}" ]]; then
    echo "${TASK}"
    exit 0
fi

# Si la tâche ne possède pas de tâche parent
PARENT=$(echo "${TASK}" | jq -r '.parent')
if [[ "${PARENT}" == "null" ]]; then
    echo "${TASK}"
    exit 0
fi

# Completion de l'age
DESCRIPTION=$(echo "${TASK}" | jq -r '.description')
AGE=$(echo "${TASK}" | jq -r '.imask')
COMPLETED_DESCRIPTION="${DESCRIPTION} (${AGE})"

# Correction de la date d'anniversaire
PARENT_DUE=$(task uuid:${PARENT} info | grep 'Due' | awk '{print $2}')
DATE=$(echo "$(( ${PARENT_DUE:0:4} + AGE ))${PARENT_DUE:4}")

# Correction du wait
WAIT_TIME=2 # Nombre de mois avant que la tâches soit visible
WAIT_MONTH=$(printf "%02d" $(( (10#${PARENT_DUE:5:2} - $WAIT_TIME - 1 + 12) % 12 + 1 )))
if (( WAIT_MONTH + WAIT_TIME > 12 )); then
WAIT=$(echo "$(( ${DATE:0:4} - 1 ))-${WAIT_MONTH}${PARENT_DUE:7}")
else
WAIT=$(echo "${DATE:0:4}-${WAIT_MONTH}${PARENT_DUE:7}")
fi

TODAY=$(date +%Y-%m-%d)
if [[ "${DATE}" < "${TODAY}" ]]; then
    FIXED_TASK=$(echo "${TASK}" | jq -c --arg value "${DATE}" '.due = $value' | jq -c --arg value "${WAIT}" '.wait = $value' | jq -c --arg value "${COMPLETED_DESCRIPTION}" '.description = $value' | jq -c --arg value "done" '.status = $value')
else
    FIXED_TASK=$(echo "${TASK}" | jq -c --arg value "${DATE}" '.due = $value' | jq -c --arg value "${WAIT}" '.wait = $value' | jq -c --arg value "${COMPLETED_DESCRIPTION}" '.description = $value')
fi

echo "${FIXED_TASK}"
exit 0
