source <(kubectl completion bash) # set up autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

alias k="kubectl"

alias v="vim"
export do="--dry-run=client -oyaml"
function ns () {
  kubectl config set-context --current --namespace=$1
}


# export drs="--dry-run=server -oyaml"
