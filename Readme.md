# TKG Tools

My set of tools I use to deploy and manage TKG (mostly TKGs) from a Linux "jumpbox".  These are likely to change a lot with the release of vSphere 8.

## Requirements

Assumes TANZU_NET_USER and TANZU_NET_PASSWORD are set in the user env or sourceable from a script 
($HOME/Documents/TanzuNet_creds).

TKG essentials and extensions (downloaded, expanded to downloads directory, apps copied to PATH eg: /usr/local/bin).  
Extensions for TKGs are 1.3.1 as per doc.

Add the bin directory to your path in .profile

if [ -d "$HOME/tkg/bin" ] ; then
    PATH="$HOME/tkg/bin:$PATH"
fi

## Tanzu Extensions (tex)

From a raw cluster install: cert-manager, kapp, contour, service-discovery/external-dns

LCM with install|update|delete

Keep any config files modified from templates in tkg/config

Do cert-manager first
tex.sh cert-manager install
Then kapp
tex.sh kapp install

### Contour
I copied the default configuration using a LoadBalancer to our config files, but didn't modify it.

cp downloads/tkg-extensions-v1.3.1+vmware.1/extensions/ingress/contour/vsphere/contour-data-values-lb.yaml.example config/contour/vsphere/contour-data-values-lb.yaml

### Service Discovery / External DNS
Copy the default configuration and modify.

cp downloads/tkg-extensions-v1.3.1+vmware.1/extensions/service-discovery/external-dns/external-dns-data-values-rfc2136-with-contour.yaml.example ./config/external-dns/

## Create Cluster

Run the script with a cluster name.  Looks for a file clusters/my-cluster.yaml, calls kubectl apply -f, then waits
for the cluster to start.  The my-cluster in the file name must be the same as as in the TanzuKubernetesCluster definition.

## AKO

Deploy the Avi Kubernetes Operator with helm so you can do Layer 7 routing and enable Ingress.
