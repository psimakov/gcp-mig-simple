#!/bin/bash

set -e

BLUE='\033[1;34m'
RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

echo -e "\n${GREEN}######################################################"
echo -e "#                                                    #"
echo -e "#  Zero-Downtime Blue/Green VM Deployments Using     #"
echo -e "#  Managed Instance Groups, Cloud Build & Terraform  #"
echo -e "#                                                    #"
echo -e "######################################################${NC}\n"

echo -e "\nSTARTED ${GREEN}teardown.sh:${NC}"

echo -e "\nIt's ${RED}safe to re-run${NC} this script to ${RED}teardown${NC} all resources.\n"
echo "> Checking GCP CLI tool is installed"
gcloud --version > /dev/null 2>&1

readonly EXPLICIT_PROJECT_ID="$1"
readonly EXPLICIT_CONSENT="$2"

if [ -z "$EXPLICIT_PROJECT_ID" ]; then
    echo "> No explicit project id provided, trying to infer"
    PROJECT_ID="$(gcloud config get-value project)"
else
    PROJECT_ID="$EXPLICIT_PROJECT_ID"
fi

if [ -z "$PROJECT_ID" ]; then
    echo "ERROR: GCP project id was not provided as parameter and could not be inferred"
    exit 1
else
    readonly PROJECT_NUM="$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')"
    if [ -z "$PROJECT_NUM" ]; then
        echo "ERROR: GCP project number could not be determined"
        exit 1
    fi
    echo -e "\nYou are about to:"
    echo -e "  * modify project ${RED}${PROJECT_ID}/${PROJECT_NUM}${NC}"
    echo -e "  * ${RED}delete${NC} all resources created by ${RED}setup.sh${NC}"
    echo -e "  * you must ${RED}manually${NC} disable APIs services\n"
fi

if [ "$EXPLICIT_CONSENT" == "yes" ]; then
  echo "Proceeding under explicit consent"
  readonly CONSENT="$EXPLICIT_CONSENT"
else
    echo -e "Enter ${BLUE}'yes'${NC} if you want to proceed:"
    read CONSENT
fi

if [ "$CONSENT" != "yes" ]; then
    echo -e "\nERROR: Aborted by user"
    exit 1
else
    echo -e "\n......................................................"
    echo -e "\n> Received user consent"
fi

echo "Deleting 'copy-of-gcp-mig-simple' source repository"
gcloud source repos delete \
    --project "$PROJECT_ID" \
    "copy-of-gcp-mig-simple" \
    --quiet || true

echo "Deleting Cloud Build triggers"
gcloud beta builds triggers delete \
    "destroy" --project "$PROJECT_ID" --quiet || true
gcloud beta builds triggers delete \
    "apply" --project "$PROJECT_ID" --quiet || true

echo -e "\n............................."

echo -e "\n${GREEN}COMPLETED!${NC}"