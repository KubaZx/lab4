#!/bin/bash

PROGNAME=$(basename "$0")
VERSION="1.0"

print_help() {
  cat <<EOF
Usage: $PROGNAME [OPTION] [ARG]

  --date,   -d        show today's date
  --logs N, -l N      create N log files (default 100)
  --error N, -e N     create N error files under error*/ (default 100)
  --init              clone this repository into cwd and add to PATH
  --help,   -h        show this help and exit

Examples:
  $PROGNAME --date
  $PROGNAME -l 30
  $PROGNAME --error
  $PROGNAME --init
EOF
}

show_date() {
  date "+%Y-%m-%d %H:%M:%S"
}

create_logs() {
  local count=${1:-100}
  for ((i=1;i<=count;i++)); do
    fname="log${i}.txt"
    echo "$fname created by $PROGNAME at $(date)" > "$fname"
  done
}

create_errors() {
  local count=${1:-100}
  for ((i=1;i<=count;i++)); do
    dir="error${i}"
    mkdir -p "$dir"
    echo "${dir}/error${i}.txt created by $PROGNAME at $(date)" > "${dir}/error${i}.txt"
  done
}

do_init() {
  if [ -d .git ]; then
    repo_url=$(git config --get remote.origin.url)
    echo "Cloning $repo_url into ./${PROGNAME}_clone"
    git clone "$repo_url" "${PROGNAME}_clone"
    echo "export PATH=\$PATH:$(pwd)/${PROGNAME}_clone" >> ~/.bashrc
    echo "Added $(pwd)/${PROGNAME}_clone to your PATH (~/.bashrc)."
  else
    echo "Error: not a git repository. Cannot infer remote URL." >&2
    exit 1
  fi
}

if [[ $# -eq 0 ]]; then
  print_help
  exit 0
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      print_help; exit 0;;
    --date|-d)
      show_date; exit 0;;
    --logs|-l)
      shift
      create_logs "$1"
      exit 0;;
    --error|-e)
      shift
      create_errors "$1"
      exit 0;;
    --init)
      do_init; exit 0;;
    *)
      echo "Unknown option: $1" >&2
      print_help
      exit 1;;
  esac
done
