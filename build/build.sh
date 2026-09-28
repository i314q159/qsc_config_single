#!/usr/bin/env bash

# 用户名
USER_NAME="admin1"

# qsc_ws
QSC_WORKSPACE="/home/$USER_NAME/qsc_ws"
QSC_WORKSPACE_BUILD="$QSC_WORKSPACE/build"
QSC_WORKSPACE_DEVEL="$QSC_WORKSPACE/devel"

rm_dir_if_exists() {
	if [ $# -eq 1 ]; then
		local dir="$1"
		[ -d "$dir" ] && rm -rf -- "$dir"
	fi
}

li_test() {
	if [ -e "/home/$USER_NAME/li_test/" ]; then

		rm_dir_if_exists "/home/$USER_NAME/li_test/sc-lio-loam-one/devel/"
		rm_dir_if_exists "/home/$USER_NAME/li_test/sc-lio-loam-one/build/"

		catkin_make \
			-C /home/$USER_NAME/li_test/sc-lio-loam-one \
			-j"$(nproc)"

		rm_dir_if_exists "/home/$USER_NAME/li_test/sc-lio-loam-two/devel/"
		rm_dir_if_exists "/home/$USER_NAME/li_test/sc-lio-loam-two/build/"

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
		rm_dir_if_exists "$QSC_WORKSPACE_BUILD"
		rm_dir_if_exists "$QSC_WORKSPACE_DEVEL"

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
