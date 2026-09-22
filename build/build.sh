#!/usr/bin/env bash

# 用户名
USER_NAME="admin1"

# qsc_ws
QSC_WORKSPACE="/home/$USER_NAME/qsc_ws"
QSC_WORKSPACE_BUILD="$QSC_WORKSPACE/build"
QSC_WORKSPACE_DEVEL="$QSC_WORKSPACE/devel"

safe_remove() {
	local file_path="$1"

	local allowed_dir="/home/$USER_NAME/"

	local real_file
	real_file=$(realpath -m "${file_path}")

	if [[ "${real_file}" == "${allowed_dir}"* && -e "${file_path}" ]]; then
		rm -rf "${file_path}"
	fi
}

li_test() {
	if [ -e "/home/$USER_NAME/li_test/" ]; then

		safe_remove /home/$USER_NAME/li_test/sc-lio-loam-one/devel/
		safe_remove /home/$USER_NAME/li_test/sc-lio-loam-one/build/

		catkin_make \
			-C /home/$USER_NAME/li_test/sc-lio-loam-one \
			-j"$(nproc)"

		safe_remove /home/$USER_NAME/li_test/sc-lio-loam-two/devel/
		safe_remove /home/$USER_NAME/li_test/sc-lio-loam-two/build/

		catkin_make \
			-C /home/$USER_NAME/li_test/sc-lio-loam-two \
			-j"$(nproc)"

		chown $USER_NAME:$USER_NAME -R /home/$USER_NAME/li_test/
	fi
}
li_test

qsc_ws() {
	if [ -e "/home/$USER_NAME/qsc_ws" ]; then
		# 删除上一台车的编译产物
		safe_remove $QSC_WORKSPACE_BUILD
		safe_remove $QSC_WORKSPACE_DEVEL

		# 编译主程序
		# shellcheck source=/dev/null
		source /opt/ros/noetic/setup.sh

		catkin_make \
			-C $QSC_WORKSPACE \
			-j"$(nproc)" \
			-DENABLE_TRANSFORM=ON

		chmod +x /home/$USER_NAME/qsc.sh

		# 修复文件权限
		echo "修复文件权限..."
		chown $USER_NAME:$USER_NAME -R $QSC_WORKSPACE
		chown $USER_NAME:$USER_NAME /home/$USER_NAME/qsc.sh

	else
		echo "请检查qss_ws位置"
	fi
}
qsc_ws
