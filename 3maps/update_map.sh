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

	if [ -e "./cxy_yanbian.txt" ]; then
		cp ./cxy_yanbian.txt $QSC_WORKSPACE/config/
	fi

	if [ -e "./cxy_fugai.txt" ]; then
		cp ./cxy_fugai.txt $QSC_WORKSPACE/config/
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
	source /opt/ros/noetic/setup.sh
	if [ -e "$QSC_WORKSPACE_SRC/addobsmap/" ]; then
		catkin_make \
			-C $QSC_WORKSPACE \
			-j 16 \
			--pkg addobsmap \
			-DENABLE_TRANSFORM=ON
	fi

	source /opt/ros/noetic/setup.sh
	if [ -e "$QSC_WORKSPACE_SRC/qscmap/" ]; then
		catkin_make \
			-C $QSC_WORKSPACE \
			-j 16 \
			--pkg qscmap \
			-DENABLE_TRANSFORM=ON
	fi

	source /opt/ros/noetic/setup.sh
	if [ -e "$QSC_WORKSPACE_SRC/realmap/" ]; then
		catkin_make \
			-C $QSC_WORKSPACE \
			-j 16 \
			--pkg realmap \
			-DENABLE_TRANSFORM=ON
	fi
}
build_map
