#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")"
function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-GPL.txt" \
		--exclude "LICENSE-MIT.txt" -av --no-perms . ~
}

if [[ "$1" == "--force" || "$1" == "-f" ]]; then
	doIt
else
	echo -n  "This may overwrite existing files in your home directory. Are you sure? (y/n) "
	read REPLY
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt
source ~/.bash_profile
