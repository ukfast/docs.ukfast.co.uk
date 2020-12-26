#!/bin/bash

# This script will do a simple check for meta information in changed *.md files

print_fail() {
  echo -e "\033[0;31m${@}\033[0m"
}

print_warn() {
  echo -e "\033[0;33m${@}\033[0m"
}

file_names="$@"
changed_files=$(echo $file_names | wc -w)
echo -e "\nChecking ${changed_files} changed files"

for f in $file_names; do

  if [ ! -f "$f" ]; then
    print_warn "$f : WARNING Is not a file or does not exist anymore."
    continue
  fi

  case $f in
    *.md )
      #check for new meta title
      newtitle=$(grep '  \.\. title:' $f >> /dev/null 2>&1; echo $?)
      if [[ "$newtitle" != "0" ]]; then
        print_fail "$f : FAIL Does not contain meta title new see readme"
        fail=1
      fi

      if [[ "$f" =~ [A-Z] ]]; then
        print_warn "$f : WARNING filepath is not lowercase"
      fi

      title_size=$(grep '\.\. title:' $f | cut -d ':' -f2 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | wc -m)
      #Meta title should exclude | UKFast Documentation
      if [[ "$title_size" -gt "43" ]]; then
        print_warn "$f : WARNING Meta title is $title_size - Max is 42 chars"
      fi

      meta=$(grep '\.\. meta::' $f >> /dev/null 2>&1; echo $?)
      if [[ "$meta" != "0" ]]; then
        print_warn "$f : WARNING Does not contain meta info"
      fi

      descr_size=$(grep '  :description:' $f | cut -d ':' -f3|wc -m)
      if [[ "$descr_size" == "1" ]]; then
        print_warn "$f : WARNING Meta description not specified"
      fi
      if [[ "$descr_size" -gt "166" ]]; then
        print_warn "$f : WARNING Meta description is longer than 165 chars"
      fi
  esac
done

if [[ "$fail" == "1" ]]; then
  exit 1
fi
