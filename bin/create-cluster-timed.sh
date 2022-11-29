#!/bin/bash

CLUSTER_NAME=$1
CLUSTER_YAML=clusters/${CLUSTER_NAME}.yaml
TKGS_NAMESPACE=development
MAX_DURATION=1800

#TODO: test for file.  check for directory.  check for directory above.
if [ -f "$CLUSTER_YAML" ]; then
    echo "$CLUSTER_YAML exists."
else 
    echo "$CLUSTER_YAML does not exist.  Exiting..."
    exit
fi

if [[ $(kubectl config get-contexts | grep ${TKGS_NAMESPACE} | grep '*') ]]; then
    echo "${TKGS_NAMESPACE} exists and is selected."
    if [[ $(kubectl get tkc | grep ${CLUSTER_NAME} ) ]]; then
      echo "Cluster ${CLUSTER_NAME} exists"
    else
      echo "Creating cluster ${CLUSTER_NAME}"
      kubectl apply -f $CLUSTER_YAML
      echo "Wait a minute to give the cluster a chance to come up before polling"
      sleep 60
    fi
    SECONDS=0
    while :
    do
      duration=${SECONDS}
      if [[ $(kubectl get tkc | grep ${CLUSTER_NAME} | awk '{ print $6 }' | grep True) ]]; then
        echo "${CLUSTER_NAME} cluster ready: Age: $(kubectl get tkc | grep ${CLUSTER_NAME} | awk '{ print $5 }')"
        break
      elif [ $(kubectl get tkc | grep ${CLUSTER_NAME} | awk '{ print $6 }' | grep False) ]; then
        echo "${CLUSTER_NAME} cluster not ready: Age: $(kubectl get tkc | grep ${CLUSTER_NAME} | awk '{ print $5 }')"
      else
        echo "no ${CLUSTER_NAME}: ${duration}"
      fi
      if [ $duration -ge $MAX_DURATION ]; then echo "Outta time"; break; fi
      sleep 10
    done
elif [[ $(kubectl config get-contexts | grep ${TKGS_NAMESPACE}) ]]; then
    echo "${TKGS_NAMESPACE} exists but is not selected"
else
    echo "${TKGS_NAMESPACE} doesn't exist"
fi
