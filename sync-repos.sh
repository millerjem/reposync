#!/usr/bin/env bash

declare -a REPOS=("$@")

REPOS_LOCATION=/repos

mkdir $REPOS_LOCATION

for r in "${REPOS[@]}"
do
  echo "Syncing ${r}..."
	cd ${REPOS_LOCATION}
  reposync -g -l -m --download-metadata --repoid=${r}
  mkdir -p ${r}/repodata 
  touch ${r}/repodata/comps.xml
  createrepo -g repodata/comps.xml ${r}
done
