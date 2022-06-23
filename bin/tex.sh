#!/bin/bash

#TEX - Tanzu Extensions management

EX_LOCATION=$HOME/tkg/downloads/tkg-extensions-v1.3.1+vmware.1
EX_CONFIG=$HOME/tkg/config

EX_CERT_LOCATION=$EX_LOCATION/cert-manager

EX_KAPP_LOCATION=$EX_LOCATION/extensions

EX_CONTOUR_LOCATION=$EX_LOCATION/extensions/ingress/contour
EX_CONTOUR_DATA_FILE=$EX_CONFIG/contour/vsphere/contour-data-values-lb.yaml

EX_DNS_LOCATION=$EX_LOCATION/extensions/service-discovery/external-dns
EX_DNS_DATA_FILE=$EX_CONFIG/external-dns/external-dns-data-values-rfc2136-with-contour.yaml

case $1 in
    cert-manager )
        case $2 in
            install )
                kubectl apply -f ${EX_CERT_LOCATION}/
                ;;
            update )
                kubectl apply -f ${EX_CERT_LOCATION}/
                ;;
            uninstall )
                kubectl delete -f ${EX_CERT_LOCATION}/
                ;;

            * )
                echo "fallout cert-manager"
                ;;
        esac
        ;;
    kapp )
        case $2 in
            install )
                kubectl apply -f ${EX_KAPP_LOCATION}/kapp-controller.yaml
                ;;
            update )
                kubectl apply -f ${EX_KAPP_LOCATION}/kapp-controller.yaml
                ;;
            uninstall )
                kubectl delete -f ${EX_KAPP_LOCATION}/kapp-controller.yaml
                ;;

            * )
                echo "fallout cert-manager"
                ;;
        esac
        ;;
    contour )
        case $2 in
            install )
                kubectl apply -f ${EX_CONTOUR_LOCATION}/namespace-role.yaml
                kubectl create secret generic contour-data-values --from-file=values.yaml=${EX_CONTOUR_DATA_FILE} -n tanzu-system-ingress
                kubectl apply -f ${EX_CONTOUR_LOCATION}/contour-extension.yaml
                ;;
            update )
                kubectl create secret generic contour-data-values --from-file=values.yaml=${EX_CONTOUR_DATA_FILE} -n tanzu-system-ingress -o yaml --dry-run | kubectl replace -f-
                ;;
            uninstall )
                kubectl delete -f ${EX_CONTOUR_LOCATION}/contour-extension.yaml
                kubectl delete -f ${EX_CONTOUR_LOCATION}/namespace-role.yaml
                ;;

            * )
                echo "fallout"
                ;;
        esac
        ;;
    dns )
        case $2 in
            install )
                kubectl apply -f ${EX_DNS_LOCATION}/namespace-role.yaml
                kubectl create secret generic external-dns-data-values --from-file=values.yaml=${EX_DNS_DATA_FILE} -n tanzu-system-service-discovery
                kubectl apply -f ${EX_DNS_LOCATION}/external-dns-extension.yaml
                ;;
            update )
                kubectl create secret generic external-dns-data-values --from-file=values.yaml=${EX_DNS_DATA_FILE} -n tanzu-system-service-discovery -o yaml --dry-run | kubectl replace -f-
                ;;
            uninstall )
                kubectl delete -f ${EX_DNS_LOCATION}/external-dns-extension.yaml
                kubectl delete -f ${EX_DNS_LOCATION}/namespace-role.yaml
                ;;

            * )
                echo "fallout"
                ;;
        esac
        ;;
    * )
        echo "usage: tex.sh [cert-manager|kapp|contour|dns] [install|update|delete]"
        ;;
esac
