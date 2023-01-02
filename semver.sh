#!/bin/bash

# Semantic Version
# Options
#    Base
#    Major
#    Minor
#    Patch
#    Custom
#
# Help
# usage

# Main function 
main() {
  # Options
  while getopts "bchmMp" opt; do
    case ${opt} in
      b )
        base
        ;;
      c )
        custom "$@"
        ;;
      h )
        usage
        exit 0
        ;;
      m )
        minor "$@"
        ;;
      M )
        major "$@"
        ;;
      p )
        patch "$@"
        ;;
      * )
        usage
        exit 1
        ;;
    esac
  done
  shift $((OPTIND -1))
}

usage() {
 echo "
  Semantic Version
  By Christian Benitez

  Usage: 
    ./version.sh [Options] [Args]
    
    Options:
      -b       Base 
      -M       Major
      -m       Minor
      -p       Patch
      -c       Custom only x.x.x
      -h       Help

    Args (Optional):
      dev
      stable
      x.x.x   Only for custom
 "
}

base() {
  echo "Base"
  local ENV=$2
  local BASE="1.0.0" 
  if [ "$ENV" = "dev" ]; then
    echo $BASE > "./version/dev.txt"
  elif [ "$ENV" = "stable" ]; then
    echo $BASE > "./version/stable.txt"
  else
    echo $BASE > "./version/dev.txt"
    echo $BASE > "./version/stable.txt"
    ENV="ALL"
  fi
  echo "${ENV}: ${BASE}"
}

custom() {
  echo "Custom"
  local BASE=$2
  local ENV=$3
  if [ "$ENV" = "dev" ]; then
    echo $BASE > "./version/dev.txt"
  elif [ "$ENV" = "stable" ]; then
    echo $BASE > "./version/stable.txt"
  else
    echo $BASE > "./version/dev.txt"
    echo $BASE > "./version/stable.txt"
    ENV="ALL"
  fi
  echo "${ENV}: ${BASE}"
}

major(){
  echo "Major"
  local ENV=$2
  local FILE="./version/stable.txt"
  if [ "$ENV" = "dev" ]; then
    FILE="./version/dev.txt"
  fi
  local VERSION=$(cat $FILE)
  echo "Version: ${VERSION}"
  local MAJOR=$(echo $VERSION | awk -F'.' '{print($1)}')
  
  MAJOR=$(($MAJOR + 1))
  VERSION="${MAJOR}.0.0"
  badge $VERSION "stable"
  echo $VERSION > $FILE
  echo "New: ${VERSION}"
}

minor(){
  echo "Minor"
  local ENV=$2
  local FILE="./version/stable.txt"
  if [ "$ENV" = "dev" ]; then
    FILE="./version/dev.txt"
  fi
  local VERSION=$(cat $FILE)
  echo "Version: ${VERSION}"
  local MAJOR=$(echo $VERSION | awk -F'.' '{print($1)}')
  local MINOR=$(echo $VERSION | awk -F'.' '{print($2)}')
  local PATCH=$(echo $VERSION | awk -F'.' '{print($3)}')
  
  MINOR=$(($MINOR + 1))
  VERSION="${MAJOR}.${MINOR}.0"
  badge $VERSION "dev"
  echo $VERSION > $FILE
  echo "New: ${VERSION}"
}

patch(){
  echo "Patch"
  local ENV=$2
  local FILE="./version/stable.txt"
  if [ "$ENV" = "dev" ]; then
    FILE="./version/dev.txt"
  fi
  local VERSION=$(cat $FILE)
  echo "Version: ${VERSION}"
  local MAJOR=$(echo $VERSION | awk -F'.' '{print($1)}')
  local MINOR=$(echo $VERSION | awk -F'.' '{print($2)}')
  local PATCH=$(echo $VERSION | awk -F'.' '{print($3)}')
  
  PATCH=$(($PATCH + 1))
  VERSION="${MAJOR}.${MINOR}.${PATCH}"
  badge $VERSION "dev"
  echo $VERSION > $FILE
  echo "New: ${VERSION}"
}

badge() {
  VERSION=$1
  ENV=$2
  COLOR="#97ca00"
  if [ "$ENV" = "dev" ]; then
    COLOR="#007BFF"
  else
    ENV="stable"
  fi
  SHIELD="badges/${ENV}.svg"
  LABEL=$ENV
  echo "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"78\" height=\"20\" role=\"img\" aria-label=\"${LABEL}: ${VERSION}\"><title>${LABEL}: ${VERSION}</title><linearGradient id=\"s\" x2=\"0\" y2=\"100%\"><stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/><stop offset=\"1\" stop-opacity=\".1\"/></linearGradient><clipPath id=\"r\"><rect width=\"78\" height=\"20\" rx=\"3\" fill=\"#fff\"/></clipPath><g clip-path=\"url(#r)\"><rect width=\"47\" height=\"20\" fill=\"#555\"/><rect x=\"47\" width=\"31\" height=\"20\" fill=\"${COLOR}\"/><rect width=\"78\" height=\"20\" fill=\"url(#s)\"/></g><g fill=\"#fff\" text-anchor=\"middle\" font-family=\"Verdana,Geneva,DejaVu Sans,sans-serif\" text-rendering=\"geometricPrecision\" font-size=\"110\"><text aria-hidden=\"true\" x=\"245\" y=\"150\" fill=\"#010101\" fill-opacity=\".3\" transform=\"scale(.1)\" textLength=\"370\">${LABEL}</text><text x=\"245\" y=\"140\" transform=\"scale(.1)\" fill=\"#fff\" textLength=\"370\">${LABEL}</text><text aria-hidden=\"true\" x=\"615\" y=\"150\" fill=\"#010101\" fill-opacity=\".3\" transform=\"scale(.1)\" textLength=\"210\">${VERSION}</text><text x=\"615\" y=\"140\" transform=\"scale(.1)\" fill=\"#fff\" textLength=\"210\">${VERSION}</text></g></svg>" > $SHIELD
}

# Init main func 
main "$@"
