# TKG Tools

My set of tools I use to deploy and manage TKG (mostly TKGs) from a Linux "jumpbox".

## Requirements

Assumes TANZU_NET_USER and TANZU_NET_PASSWORD are set in the user env or sourceable from a script 
($HOME/Documents/TanzuNet_creds).

TKG essentials and extensions (downloaded, expanded to downloads, apps copied to PATH eg: /usr/local/bin).  Extensions for
TKGs are set to 1.3.1 as per doc.

Add the bin directory to your path in .profile

if [ -d "$HOME/tkg/bin" ] ; then
    PATH="$HOME/tkg/bin:$PATH"
fi

## Create Cluster

Run the script with a cluster name.  Looks for a file clusters/<name>.yaml, calls kubectl apply -f, then waits
for the cluster to start.  The <name> in the file name must be the same as as in the TanzuKubernetesCluster definition.

## AKO

Deploy the Avi Kubernetes Operator with helm so you can do Layer 7 routing and enable Ingress.
