#!/bin/bash

set -euo pipefail

PREFIX="rovsuser"

PROJECTS=$(oc get projects \
    -o custom-columns=NAME:.metadata.name \
    --no-headers | grep "^${PREFIX}" || true)

if [[ -z "$PROJECTS" ]]; then
    echo "No matching projects found."
    exit 0
fi

echo "Current cluster: $(oc whoami --show-server)"
echo ""
echo "Projects to delete:"
echo "$PROJECTS"
echo ""
echo "Total: $(echo "$PROJECTS" | wc -l | tr -d ' ') projects"
echo ""

read -r -p "Type DELETE to confirm: " CONFIRM

if [[ "$CONFIRM" != "DELETE" ]]; then
    echo "Operation cancelled."
    exit 0
fi

while IFS= read -r PROJECT; do
    echo "Deleting project: $PROJECT"
    oc delete project "$PROJECT" --wait=false
done <<< "$PROJECTS"

echo ""
echo "All deletion requests submitted."