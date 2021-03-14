# Script configs
packages_add=(
)
packages_del=(
)
paddheader="packages_add=("
pdelheader="packages_del=("
# Script configs
packages=(${packages_add[*]} ${packages_del[*]})
# Only use in count,Don't try to Execute it
Option=$1
PKG=$2
isdelete=0
version="Script V1.5 --by huajijam@gmail.com"

# sub-Program
help(){
printf "\nUsage:\n%-2s $0 --Option <package>\nOptions:\n%-4s-add # Write a add package to the script\n%-4s-remove # Write a remove package from the script\n%-4s-delete # Delete a package from the script\n%-4s-list # Show all packages in the script\n%-4s--get-all # Get all packages that was added\n%-4s--run-only # Only run command but not adding in the script\n%-4s(e.g. '$0 --run-only +<package>')\n%-4s--add-only # Only add package but not running this time\n%-4s--remove-only # Only remove package but not running this time\n%-4s--version # Print Version of this script\n"
}

add(){
echo -e "Writing "+$PKG" to script"
if [[ `grep -c "$PKG" "$0"` -ne '0' ]];then # Check if exist
  echo -e "Package: $PKG exist"
  delproc=add
  delete
fi
sed -i "/$paddheader/a $PKG" $0 # Write
if [[ $isdelete = 1 ]];then # local bad line in delete
  let pline=${#packages_add[*]}+${#packages_del[*]}+7
else
  let pline=${#packages_add[*]}+${#packages_del[*]}+8
fi
sed -i "${pline}d" $0
stats=add
echo -e "Writing package config: +$PKG Successful"
echo -e
}

remove(){
echo -e "Writing -$PKG to script"
if [[ `grep -c "$PKG" "$0"` -ne '0' ]];then
  echo -e "Package: -$PKG exist,removing"
  delproc=remove
  delete
fi
sed -i "/$pdelheader/a $PKG" $0 # Write
if [[ $isdelete = 1 ]];then # local bad line in delete
  let pline=${#packages_add[*]}+${#packages_del[*]}+8
else
  let pline=${#packages_add[*]}+${#packages_del[*]}+9
fi
sed -i "${pline}d" $0
stats=remove
echo -e "Writing package config: "-$PKG" Successful"
echo -e
}

delete(){
if [[ `grep -c "$PKG" "$0"` -ne '0' ]];then # Check if file exist
echo -e "The following lines will be deleted,press Y to Confirm"
echo -e "<lines>:<packages>"
grep -ne "$PKG" "$0"
  while true ;do
    echo -e
    read -p "Are You Sure?(y/N)" input
    case $input in
      [yY][eE][sS]|[yY])
        sed -i "/$PKG/d" $0
        # Using $delproc to customize print out
        if [[ $delproc = "main" ]];then
          echo -e "Package: $PKG delete"
        elif [[ $delproc = "add" || $delproc = "remove" ]];then
          echo -e "Remove exist Package Succeed"
          isdelete=1
        fi
        return
        ;;
      [nN][oO]|[Nn][oO]|[nN])
        # Using $delproc to customize print out
        if [[ $delproc = "main" ]];then
          echo -e "Delete Package: $PKG Cancel"
        elif [[ $delproc = "add" || $delproc = "remove" ]];then
          echo -e "Remove exist Package Cancel"
        fi
        exit
        ;;
      *)
        echo "Invalid Input"
        ;;
    esac
  done
else
  echo -e "Package not exist"
  exit
fi
}

list(){
printf "there are ${#packages[*]} packages has been configed in the script:\n"
if [[ -n "${packages_add}" ]];then
  printf "\n${#packages_add[@]} packages has been configed in add:"
  for i in "${!packages_add[*]}";do
    printf "%s\t%s\n""$i. ""${packages_add[$i]}"
  done
  unset i
  echo -e
fi
if [[ -n "${packages_del}" ]];then
  printf "\n${#packages_del[@]} packages has been configed in remove:"
  for i in "${!packages_del[*]}";do
    printf "%s\t%s\n""$i. ""${packages_del[$i]}"
  done
  unset i
  echo -e
fi
}

getall(){
su -c dumpsys deviceidle whitelist
}

run(){
echo -e "Running Script Configs"
# if add and delete exist
if [[ -n ${packages_add[*]} && -n ${packages_del[*]} ]];then
  for i in ${packages_add[*]};do
    su -c dumpsys deviceidle whitelist +$i
  done
  unset i
# must repeat and split to twice
  for i in ${packages_del[*]};do
    su -c dumpsys deviceidle whitelist -$i
  done
  unset i
fi
# if Only exist add
if [[ -n ${packages_add[*]} && -z ${packages_del[*]} ]];then
  for i in ${packages_add[*]};do
    su -c dumpsys deviceidle whitelist +$i
  done
  unset i
fi
# if Only exist delete
if [[ -z ${packages_add[*]} && -n ${packages_del[*]} ]];then
  for i in ${packages_del[*]};do
    su -c dumpsys deviceidle whitelist -$i
  done
  unset i
fi
# because Script process cannot get update in the process cache
if [[ $stats = add ]];then
  su -c dumpsys deviceidle whitelist +$PKG
  unset stats
fi
if [[ $stats = remove ]];then
  su -c dumpsys deviceidle whitelist -$PKG
  unset stats
fi
echo -e "Running Config Succeed"
}

runonly(){
echo -e "Running Config "$2""
su -c dumpsys deviceidle whitelist $2
echo -e "Running Config Succeed"
}
# sub-Program
# Execute Program
if [[ -n $(command -v su) ]];then # Check if su exist
  if [[ -z "${1:-}" ]];then
  run
  elif [[ "${1:-}" = "-add" ]] && [[ -n "$2" ]];then
    add
    sleep 0.5
    run
  elif [[ "${1:-}" = "-remove" ]] && [[ -n "$2" ]];then
    remove
    sleep 0.5
    run
  elif [[ "${1:-}" = "-delete" ]] && [[ -n "$2" ]];then
    delproc=main
    delete
  elif [[ "${1:-}" = "-list" ]];then
    list
  elif [[ "${1:-}" = "--get-all" ]];then
    getall
  elif [[ "${1:-}" = "--run-only" ]] && [[ -n "$2" ]];then
    runonly
  elif [[ "${1:-}" = "--add-only" ]] && [[ -n "$2" ]];then
    add
  elif [[ "${1:-}" = "--remove-only" ]] && [[ -n "$2" ]];then
    remove
  elif [[ "${1:-}" = "--version" ]];then
      echo $version
  elif [[ "${1:-}" = -[Hh][Ee][Ll][Pp] || "${1:-}" = --[Hh][Ee][Ll][Pp] || "${1:-}" = -[Hh] ]];then
    help
  else
    printf "Wrong Options: $0 $Option $PKG"
    help
  fi
else
  echo -e "Cannot find Android su Command,exiting...."
fi
unset Option
unset PKG
unset pline
unset delproc
exit
xit
