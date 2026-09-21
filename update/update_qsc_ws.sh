#!/usr/bin/env bash

TODAY=$(date +%Y-%m-%d)

USER_NAME="admin1"
QSC_ZIP="qsc_ws.zip"

QSC_WORKSPACE="/home/$USER_NAME/qsc_ws"
QSC_WORKSPACE_BUILD="$QSC_WORKSPACE/build"
QSC_WORKSPACE_DEVEL="$QSC_WORKSPACE/devel"
# QSC_WORKSPACE_LIB="$QSC_WORKSPACE/devel/lib"
QSC_WORKSPACE_SRC="$QSC_WORKSPACE/src"

safe_remove() {
	local file_path="$1"

	local allowed_dir="/home/$USER_NAME/"

	local real_file
	real_file=$(realpath -m "${file_path}")

	if [[ "${real_file}" == "${allowed_dir}"* && -e "${file_path}" ]]; then
		rm -rf "${file_path}"
	fi
}

# 备份完整 qsc_ws 空间，不做压缩黑名单处理
backup_qsc_ws() {
	BACKUP_ROOT="/home/$USER_NAME/backup"
	BACKUP_TODAY=$BACKUP_ROOT/$TODAY
	mkdir -pv "$BACKUP_TODAY"

	safe_remove "/home/$USER_NAME/$QSC_ZIP"

	cd /home/$USER_NAME &&
		zip -r $QSC_ZIP qsc_ws/ qsc.sh \
			-x="qsc_ws/devel/*" \
			-x="qsc_ws/build/*" &&
		mv ./$QSC_ZIP "$BACKUP_TODAY"
}
backup_qsc_ws

# 备份 3maps
backup_map() {
	THREE_MAPS_ROOT="/home/$USER_NAME/3maps"
	THREE_MAPS=$THREE_MAPS_ROOT/$TODAY

	mkdir -pv $THREE_MAPS_ROOT
	mkdir -pv "$THREE_MAPS"

	if [ -e "$QSC_WORKSPACE_SRC/addobsmap/" ]; then
		cd $QSC_WORKSPACE_SRC && tar -zcvf addObsMap.tgz addobsmap/ && mv ./addObsMap.tgz "$THREE_MAPS/"
	fi

	if [ -e "$QSC_WORKSPACE_SRC/qscmap/" ]; then
		cd $QSC_WORKSPACE_SRC && tar -zcvf qscmap.tgz qscmap/ && mv ./qscmap.tgz "$THREE_MAPS/"
	fi

	if [ -e "$QSC_WORKSPACE_SRC/realmap/" ]; then
		cd $QSC_WORKSPACE_SRC && tar -zcvf realMap.tgz realmap/ && mv ./realMap.tgz "$THREE_MAPS/"
	fi

	if [ -e "$QSC_WORKSPACE/config/cxy_yanbian.txt" ]; then
		cp $QSC_WORKSPACE/config/cxy_yanbian.txt "$THREE_MAPS/"
	fi

	if [ -e "$QSC_WORKSPACE/config/cxy_fugai.txt" ]; then
		cp $QSC_WORKSPACE/config/cxy_fugai.txt "$THREE_MAPS/"
	fi

	if [ -e "$QSC_WORKSPACE/customPath/" ]; then
		cd $QSC_WORKSPACE && tar -zcvf customPath.tgz customPath/ && mv ./customPath.tgz "$THREE_MAPS/"
	fi

	if [ -e "$QSC_WORKSPACE/config/config.txt" ]; then
		cp $QSC_WORKSPACE/config/config.txt "$THREE_MAPS/"
	fi

	if [ -e "$QSC_WORKSPACE_SRC/lidar_get_reflector/config/params_ls2pc_filter.yaml" ]; then
		cp $QSC_WORKSPACE_SRC/lidar_get_reflector/config/params_ls2pc_filter.yaml "$THREE_MAPS/"
	fi

	if [ -e "$QSC_WORKSPACE_SRC/lidar_get_reflector/config/params.yaml" ]; then
		cp $QSC_WORKSPACE_SRC/lidar_get_reflector/config/params.yaml "$THREE_MAPS/"
	fi

}
backup_map

# 移除旧 qsc_ws
remove_qsc_ws() {
	safe_remove "$QSC_WORKSPACE"
	safe_remove "/home/$USER_NAME/qsc.sh"
}
remove_qsc_ws

# 下载平台上的 qsc_ws.zip
dl_qsc_ws() {
	local QSC_WS_URL="https://jiqiren.zkzc123.com/qsc_soft/qsc_ws.zip"

	safe_remove "/home/$USER_NAME/$QSC_ZIP"

	if [ ! -e "/home/$USER_NAME/$QSC_ZIP" ]; then
		curl -fSL $QSC_WS_URL -o "/home/$USER_NAME/$QSC_ZIP"
	fi

	unzip -q -o /home/$USER_NAME/$QSC_ZIP "qsc_ws/*" -d /home/$USER_NAME/
	unzip -q -o /home/$USER_NAME/$QSC_ZIP "qsc.sh" -d /home/$USER_NAME/
}
dl_qsc_ws

# 恢复当天日期的 3maps 里面内容
update_map() {
	THREE_MAPS_ROOT="/home/$USER_NAME/3maps"
	THREE_MAPS=$THREE_MAPS_ROOT/$TODAY

	if [ -e "$THREE_MAPS/addObsMap.tgz" ]; then
		safe_remove $QSC_WORKSPACE_SRC/addobsmap/

		cd "$THREE_MAPS" && tar -zxvf "./addObsMap.tgz" -C $QSC_WORKSPACE_SRC/
	fi

	if [ -e "$THREE_MAPS/qscmap.tgz" ]; then
		safe_remove $QSC_WORKSPACE_SRC/qscmap/

		cd "$THREE_MAPS" && tar -zxvf "./qscmap.tgz" -C $QSC_WORKSPACE_SRC/
	fi

	if [ -e "$THREE_MAPS/realMap.tgz" ]; then
		safe_remove $QSC_WORKSPACE_SRC/realmap/

		cd "$THREE_MAPS" && tar -zxvf "./realMap.tgz" -C $QSC_WORKSPACE_SRC/
	fi

	if [ -e "$THREE_MAPS/cxy_yanbian.txt" ]; then
		cp "$THREE_MAPS/cxy_yanbian.txt" $QSC_WORKSPACE/config/
	fi

	if [ -e "$THREE_MAPS/cxy_fugai.txt" ]; then
		cp "$THREE_MAPS/cxy_fugai.txt" $QSC_WORKSPACE/config/
	fi

	if [ -e "$THREE_MAPS/customPath.tgz" ]; then
		safe_remove $QSC_WORKSPACE/customPath/

		cd "$THREE_MAPS" && tar -zxvf "./customPath.tgz" -C $QSC_WORKSPACE/
	fi

	if [ -e "$THREE_MAPS/config.txt" ]; then
		cp "$THREE_MAPS/config.txt" $QSC_WORKSPACE/config/
	fi

	if [ -e "$THREE_MAPS/params_ls2pc_filter.yaml" ]; then
		cp "$THREE_MAPS/params_ls2pc_filter.yaml" $QSC_WORKSPACE_SRC/lidar_get_reflector/config/
	fi

}
update_map

# TODO - 雷达补丁
# update_lidar() {
# 	local LIDAR_URL="https://jiqiren.zkzc123.com/qsc_soft/lidar_fairy_48_airy.zip"
# }
# update_lidar

# qsc_ws 完整编译
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
			-j 16 \
			-DENABLE_TRANSFORM=ON

		chmod +x /home/$USER_NAME/qsc.sh

	else
		echo "请检查qws_ws位置"
	fi
}
qsc_ws
