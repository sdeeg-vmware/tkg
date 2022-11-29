#K8s commands.  Source in .bashrc or .profile or such

alias k='kubectl'
alias kd='kubectl describe'
alias kgx='kubectl config get-contexts'

# Stolen from K8s docs
# short alias to set/show context/namespace (only works for bash and bash-compatible shells, current context to be set before using kn to set namespace) 
alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'
alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'

# WIP - This probably doesn't work.
# function posh()
# {
#     if [[ $1 == "-c" ]] ; then
#         if [[ -n $2 && -n $3 ]] ; then
#             kubectl exec --stdin --tty $3 -c $2 -- /bin/sh
#             exit 1
#         fi
#     else if [[ $2 == "-c" ]] ; then
#         if [[ -n $3 ]] ; then
#             kubectl exec --stdin --tty $1 -c $3 -- /bin/sh
#             exit 1
#         fi
#     else if [[ -n $1 ]] ; then
#         kubectl exec --stdin --tty $1 -- /bin/sh
#         exit 1
#     fi
#     echo "usage: posh pod_name [-c container_name]"
# }
alias posh='f() { [ "$1" ] && kubectl exec --stdin --tty $1 -- /bin/sh || echo "usage: posh pod_name" ; } ; f'
