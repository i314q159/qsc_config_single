#!/usr/bin/env bash

set -euo pipefail

USER_NAME="admin1"

safe_remove() {
	local file_path="$1"

	local allowed_dir="/home/$USER_NAME/"

	local real_file
	real_file=$(realpath -m "${file_path}")

	if [[ "${real_file}" == "${allowed_dir}"* && -e "${file_path}" ]]; then
		rm -rf "${file_path}"
	fi
}

remove_old_pack() {
	if [ -e "/home/$USER_NAME/pack/" ]; then
		safe_remove "/home/$USER_NAME/pack/"
	fi

	if [ -e "/home/$USER_NAME/pack.zip" ]; then
		safe_remove "/home/$USER_NAME/pack.zip"
	fi
}
remove_old_pack

pack_config() {
	if [ ! -e "./pack.zip" ]; then
		sudo -u "${USER_NAME}" curl -fSL "http://jiqiren.zkzc123.com/qsc_soft/pack.zip" -o ./pack.zip
	fi

	sudo -u $USER_NAME unzip -q -o ./pack.zip -d /home/$USER_NAME/

	if [ ! -e "/home/$USER_NAME/pack/ROS_Qt_Test-x86_64.AppImage" ]; then
		sudo -u $USER_NAME ln -s /home/$USER_NAME/pack/ROS_Qt_Test-x86_64.AppImage /home/$USER_NAME/桌面/
	fi
}
pack_config

touch /home/$USER_NAME/pack/update.txt
echo "2026-8-11" >/home/$USER_NAME/pack/update.txt
