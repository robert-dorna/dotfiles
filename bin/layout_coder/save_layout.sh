#!/usr/bin/env bash

workspaceFile=$HOME/Projects/dotfiles/nixos/layout_coder/workspace.json

if [ -z "$1" ]; then
  echo "error: give a destination workspace number"
  exit 1
fi

verticalOptString="-v"

if ! [ -z "$2" ]; then
  if [ "$2" != "$verticalOptString" ]; then
    echo "error: optional second option can only be: $verticalOptString"
    exit 1
  fi
fi

i3-save-tree --workspace $1 > $workspaceFile

if [ "$2" = "$verticalOptString" ]; then
  cat > $workspaceFile.tmp <<_EOF
{
    "layout": "splitv",
    "percent": 0.5,
    "type": "con",
    "nodes": [
_EOF
  cat $workspaceFile >> $workspaceFile.tmp
  cat >> $workspaceFile.tmp <<_EOF
    ]
}
_EOF
  rm $workspaceFile
  mv $workspaceFile.tmp $workspaceFile
fi

sd -f m '}(\n*)\{' '},$1{' $workspaceFile

if [ "$3" = "keep" ]; then
  sd '(\s*)// "' '$1  "' $workspaceFile
else
  sd '(\s*)// "instance(.*),' '$1  "instance$2' $workspaceFile
fi

sd '\s*//.*' '' $workspaceFile
# sed -i 's|^\(\s*\)// "|\1"|g; /^\s*\/\//d' ~/$workspaceFile
#!/usr/bin/env bash

