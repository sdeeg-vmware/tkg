
TARGET_NAMESPACE=avi-system
MAX_DURATION=1800

case $1 in
    delete )
        if [[ $(kubectl get ns | grep ${TARGET_NAMESPACE}) ]]; then
            echo "Namespace ${TARGET_NAMESPACE} exists"
            helm delete $(helm list -n ${TARGET_NAMESPACE} -q) -n ${TARGET_NAMESPACE}
            kubectl delete ns ${TARGET_NAMESPACE}
        else
            echo "Can't delete.  Namespace ${TARGET_NAMESPACE} doesn't exist.  :-("
        fi
        ;;

    install )
        if [[ $(kubectl get ns | grep ${TARGET_NAMESPACE}) ]]; then
            echo "Namespace ${TARGET_NAMESPACE} exists"
        else
            echo "Creating namespace ${TARGET_NAMESPACE}"
            kubectl create ns ${TARGET_NAMESPACE}
        fi
        helm install  ako/ako  --generate-name --version 1.6.1 -f ./ako-values.yaml --namespace=${TARGET_NAMESPACE}
        ;;

    * )
        echo "fallout"
        ;;
esac
