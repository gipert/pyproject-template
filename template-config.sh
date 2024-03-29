#!/usr/bin/env bash

echo -n ">>> GitHub user/organization: "; read -r ghuser
echo -n ">>> GitHub repository name: "; read -r gitrepo
echo -n ">>> Python package name (leave empty if equal to GitHub repository name): "; read -r pypkg

[[ ! "$pypkg" ]] && pypkg="$gitrepo"

mv src/pkgplaceholder src/"$pypkg"

# shellcheck disable=SC2046
sed -i -e "s|ghuserplaceholder|$ghuser|g" \
       -e "s|repoplaceholder|$gitrepo|g" \
       -e "s|pkgplaceholder|$pypkg|g" \
       -- $(find . -type f -not -path "./.git/*")

echo -n "Remove the .git/ folder (recommended)? [y/n] "; read -r answer
if [[ "$answer" == "y" ]]; then
   rm -rf .git

   echo -n "Initialize a new Git repository? This will:
 - run git-init
 - add https://github.com/$ghuser/$gitrepo as remote (origin)
 - create a first commit
? [y/n] ";
   read -r answer
   if [[ "$answer" == "y" ]]; then
      git init
      git remote add origin https://github.com/"$ghuser/$gitrepo"
      git add -- . :!"template-config.sh"
      git commit -m "Import and configure pyproject-template"
   fi
fi

echo "
>>> Continue configuring your package by following instruction in the README
"
