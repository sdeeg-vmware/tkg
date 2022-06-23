#Script assumes TANZU_NET_USER and TANZU_NET_PASSWORD exist.  We'll try to source them from a file.
#TODO: test if file exists
source $HOME/Documents/TanzuNet_creds

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:ab0a3539da241a6ea59c75c0743e9058511d7c56312ea3906178ec0f3491f51d
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=$TANZU_NET_USER
export INSTALL_REGISTRY_PASSWORD=$TANZU_NET_PASSWORD

function createKAppNS() {
echo "## Creating namespace kapp-controller"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: kapp-controller
EOF
}

function createKAppSecret() {
echo "## Creating secret kapp-controller-config"
cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  caCerts: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUVlakNDQXVLZ0F3SUJBZ0lSQUxHU3ZTQlhzb200OUNWaU5XcmxPUnN3RFFZSktvWklodmNOQVFFTEJRQXcKVlRFZU1Cd0dBMVVFQ2hNVmJXdGpaWEowSUdSbGRtVnNiM0J0Wlc1MElFTkJNUlV3RXdZRFZRUUxEQXh3YVhadgpkR0ZzUUhWa1pYWXhIREFhQmdOVkJBTU1FMjFyWTJWeWRDQndhWFp2ZEdGc1FIVmtaWFl3SGhjTk1qQXdOVEk0Ck1UWXhOekEzV2hjTk16QXdOVEk0TVRZeE56QTNXakJWTVI0d0hBWURWUVFLRXhWdGEyTmxjblFnWkdWMlpXeHYKY0cxbGJuUWdRMEV4RlRBVEJnTlZCQXNNREhCcGRtOTBZV3hBZFdSbGRqRWNNQm9HQTFVRUF3d1RiV3RqWlhKMApJSEJwZG05MFlXeEFkV1JsZGpDQ0FhSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnR1BBRENDQVlvQ2dnR0JBTWRaCjZHc2ZNYnpFdEtidGFTUTVOSFpYeEUvTG5uWThrTzVrTUFjOXR2Rzd4aEt6Q1JFZWh3cUN2emF1MHdwdVdDalUKNkZaUEZhbDZ4QTdPRHlabVJmYkhGRFZkVGhpT2gzV01qT2JFdm1KVVJnaTZRUGxTcFNiazBzMmZOYUcva1pEUAp0eEhmUW1yYVk0SlBvbUhrdUNzUkpJTGh2ajZSQzIrcElQWWRsNlB2OW1KQnh1WmpLNTRvVzdtUWFKaVdCdnFXCk9MVUFQZk5LeVY5Qis5SGZIb3dLZEwybk8yUXQwRllUTFE4SHZwQkgzUTNDZ0F0VjZSQkJlUFBnMmlCZDdURFcKUHB0ZXZNMDAwdnFUYTBmbDRXdEw3SEgydjNKTnlGT2xqbzB0S0FKZ3p5bVVRUjNISmo5dUZydVNRV1Nqb3B0eQpYVlQxdzlzSmpUZXdsajJsSWk3Rk56MkRNWnRXYkpjNkUzOWFqU3ovcmltUTJ5Y2RuT0lLN0RzWS9XZVJ6TWh4CkE0b29HcThnOHdjK1dwbVJSYWVYeWpvSTZuMklCVDVoaVN3alVWOFNWMmlJOEovakdjS0R1NlcrbnVpV3JvN2kKb1lobkVrZ2h5L2wwVG1WbmNTUTFPRkNqdjFkRHlDbm9UR0RvWGNHMXZNc09VaUdyb3R4Mkd2dUp5eU5peFFJRApBUUFCbzBVd1F6QU9CZ05WSFE4QkFmOEVCQU1DQWdRd0VnWURWUjBUQVFIL0JBZ3dCZ0VCL3dJQkFEQWRCZ05WCkhRNEVGZ1FVb0cxUnZVaE9yM0dDYjZPbWxHOXhOSC83VGt3d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dHQkFKN3UKV0Jpc0lPVGQ4VFpER1VNdndKSGRQMHFKL0ZKL0ozeXEvTDNEZU16cFFmZTJEOTZNMFI2TUoySjFXSzEzUGdoSwp0U3hhaFY2QXJHdnlnazlhTis3dEp3eTBQNW1MVFFPQStLTjhIS1JPR2tVTUw1SFk2QUE2blZuUEpZVVhvMm5YCjRaZHh4NUZUQlludEdJWW93UE5acHlNb1dWQnZxYnhzcEdPYlhaWXhMb0tpQlVlRzVEMjZMekh5WlM1MHd5Y2EKdFBlTzFQalc1MlJTNDluZUdBZ2VIK08rMEJ3a1lUY1dvQWpVcXJPalVITFh5Y09jMlc3YkJpUUphWlNHdlZtUAo4RnhpcXkyWU85V1Rvd0hyWDkxdkhPeVRBRW56aFhvRWN3aXZ3bzdTT1Rab21OekV5TThqbnY1K3ljVDBZZzNhCnFhSmIzRFlvc0VsMHZrTC9Fa1ZMNnd2YkNwK3cyclhKQzBkR3Y2N0dCK1hyRjNnQ2dmZGh1QittU05hd1FzMG0KbHpSdTI2UkJwWkxIdUZsZnQyTFVZMXBsVm1RcnREU2RTK3RBbmRYSjd0NUN3SFRFMDJrbjNobGI4WkJiS09ibgpzL2VLSkZGbTF4SU1IWXJBTTVnazFXVmllRm5iR2R4TVpoYlBVak05Q1lBVUFWVkpoN05GM3NtS05WeDVrUT09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
kind: Secret
metadata:
  name: kapp-controller-config
  namespace: kapp-controller
type: Opaque
EOF
}

CURRENT_DIR=pwd
cd $HOME/tkg/downloads/tanzu-cluster-essentials

case $1 in
    install )
        createKAppNS
        createKAppSecret
        ./install.sh --yes
        ;;

    uninstall )
        ./uninstall.sh --yes
        ;;

    * )
        echo "fallout"
        ;;
esac

cd ${CURRENT_DIR}