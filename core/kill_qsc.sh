#!/usr/bin/env bash

kill_qsc() {
	pkill -f roslaunch
	rosnode kill -a
	pkill rosmaster
	pkill rosout
}
kill_qsc
