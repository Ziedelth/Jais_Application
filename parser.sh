#!/bin/bash

function getUpgradableDependencies() {
  flutter pub outdated >pub_outdated.txt && sed -i -e 's/\s\+/ /g' pub_outdated.txt
  sed -n '/direct dependencies:/,/transitive dependencies:/p' pub_outdated.txt >pub_outdated_clean.txt
  sed -i '/direct dependencies:/d' pub_outdated_clean.txt
  sed -i '/transitive dependencies:/d' pub_outdated_clean.txt
  sed -i '/dev_dependencies:/d' pub_outdated_clean.txt
  sed -i '/^$/d' pub_outdated_clean.txt
}

# Go to each dependency directory and get the number of upgradable dependencies
function getUpgradableDependenciesPerDependency() {
  IFS=$'\n' read -d '' -r -a lines < <(find dependencies -type d -mindepth 1 -maxdepth 1)

  for line in "${lines[@]}"; do
    echo "$line"
    cd "$line" || exit
    getUpgradableDependencies
    IFS=$'\n' read -d '' -r -a dependencies <pub_outdated_clean.txt
    rm pub_outdated.txt pub_outdated_clean.txt
    cd ../..

    # If dependencies are not empty
    if [ -n "${dependencies[*]}" ]; then
      echo "Found upgradable dependencies in $line" >>upgradable_dependencies.txt
      printf '\n' >>upgradable_dependencies.txt

      for dependency in "${dependencies[@]}"; do
        # Split dependency with ' '
        IFS=' ' read -r -a dependency_array <<<"$dependency"
        echo "- ${dependency_array[0]} : Current version: ${dependency_array[1]} - Upgradable: ${dependency_array[3]}" >>upgradable_dependencies.txt
      done
      printf '\n' >>upgradable_dependencies.txt
      printf '\n' >>upgradable_dependencies.txt
    fi
  done
}

getUpgradableDependenciesPerDependency

echo "root"
getUpgradableDependencies
IFS=$'\n' read -d '' -r -a dependencies <pub_outdated_clean.txt
rm pub_outdated.txt pub_outdated_clean.txt

# If dependencies are not empty
if [ -n "${dependencies[*]}" ]; then
  echo "Found upgradable dependencies in root" >>upgradable_dependencies.txt
  printf '\n' >>upgradable_dependencies.txt

  for dependency in "${dependencies[@]}"; do
    # Split dependency with ' '
    IFS=' ' read -r -a dependency_array <<<"$dependency"
    echo "- ${dependency_array[0]} : Current version: ${dependency_array[1]} - Upgradable: ${dependency_array[3]}" >>upgradable_dependencies.txt
  done
  printf '\n' >>upgradable_dependencies.txt
  printf '\n' >>upgradable_dependencies.txt
fi
