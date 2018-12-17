readme() {
  local file=$(ls -1 $PWD | rg -i 'readme' --color never)
  if [ "$file" = "" ];then
    >&2 echo "Could not find any README file."
    return 1
  fi
  mdv $PWD/$file | less
  return 0
}
