#!/usr/bin/env bash

USER_NAME="admin1"
QSC_WORKSPACE="/home/$USER_NAME/qsc_ws"
QSC_WORKSPACE_BUILD="$QSC_WORKSPACE/build"
QSC_WORKSPACE_LIB="$QSC_WORKSPACE/devel/lib"
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

update_map() {
	if [ -e "./addObsMap.tgz" ]; then
		safe_remove $QSC_WORKSPACE_SRC/addobsmap/
		safe_remove $QSC_WORKSPACE_BUILD/addobsmap/
		safe_remove $QSC_WORKSPACE_LIB/addobsmap/

		tar -zxvf ./addObsMap.tgz -C $QSC_WORKSPACE_SRC/
	fi

	if [ -e "./qscmap.tgz" ]; then
		safe_remove $QSC_WORKSPACE_SRC/qscmap/
		safe_remove $QSC_WORKSPACE_BUILD/qscmap/
		safe_remove $QSC_WORKSPACE_LIB/qscmap/

		tar -zxvf ./qscmap.tgz -C $QSC_WORKSPACE_SRC/
	fi

	if [ -e "./realMap.tgz" ]; then
		safe_remove $QSC_WORKSPACE_SRC/realmap/
		safe_remove $QSC_WORKSPACE_BUILD/realmap/
		safe_remove $QSC_WORKSPACE_LIB/realmap/

		tar -zxvf ./realMap.tgz -C $QSC_WORKSPACE_SRC/
	fi

	# 适配多层轨迹：恢复所有 cxy_yanbian*.txt
	FILES_YANBIAN=(./cxy_yanbian*.txt)
	if [[ ${#FILES_YANBIAN[@]} -gt 0 ]]; then
		cp "${FILES_YANBIAN[@]}" "$QSC_WORKSPACE/config/"
	fi

	# 适配多层轨迹：恢复所有 cxy_fugai*.txt
	FILES_FUGAI=(./cxy_fugai*.txt)
	if [[ ${#FILES_FUGAI[@]} -gt 0 ]]; then
		cp "${FILES_FUGAI[@]}" "$QSC_WORKSPACE/config/"
	fi

	if [ -e "./customPath.tgz" ]; then
		safe_remove $QSC_WORKSPACE/customPath/

		tar -zxvf ./customPath.tgz -C $QSC_WORKSPACE/
	fi

	if [ -e "./config.txt" ]; then
		cp ./config.txt $QSC_WORKSPACE/config/
	fi

	if [ -e "./params_ls2pc_filter.yaml" ]; then
		cp ./params_ls2pc_filter.yaml $QSC_WORKSPACE_SRC/lidar_get_reflector/config/
	fi

}
update_map

build_map() {
	# shellcheck source=/dev/null
	source /opt/ros/noetic/setup.sh
	catkin_make \
		-C $QSC_WORKSPACE \
		-j 16 \
		-DENABLE_TRANSFORM=ON
}
build_map
