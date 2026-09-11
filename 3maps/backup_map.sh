#!/usr/bin/env bash

USER_NAME="admin1"
QSC_WORKSPACE="/home/$USER_NAME/qsc_ws"
QSC_WORKSPACE_SRC="$QSC_WORKSPACE/src"

THREE_MAPS_ROOT="/home/$USER_NAME/3maps"
TODAY=$(date +%Y-%m-%d)
THREE_MAPS=$THREE_MAPS_ROOT/$TODAY

backup_map() {
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
