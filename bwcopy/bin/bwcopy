#!/usr/bin/env zsh

PASSWORD_NAME=$1

if [[ -z $PASSWORD_NAME ]] then;
	echo "Pass password name as the first argument"
	return 1
fi

bw get password $PASSWORD_NAME | xclip -selection clipboard
