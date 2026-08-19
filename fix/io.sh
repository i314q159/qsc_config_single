#!/usr/bin/env bash

# ttyS2
# chmod 777 /dev/ttyS2
cat >/etc/udev/rules.d/70-ttyS2.rules <<EOF
KERNEL=="ttyS2", GROUP="dialout", MODE="0777"
EOF

# 添加用户到 dialout 组
usermod -aG dialout admin1

# 检查 ttyS2 权限
# ls -l /dev/ttyS2

# can device
# can1 is testing for new imu device
cat >/etc/udev/rules.d/80-can.rules <<EOF
KERNEL=="can0", SUBSYSTEM=="net", ACTION=="add", RUN+="/usr/sbin/ip link set can0 type can bitrate 500000"
KERNEL=="can0", SUBSYSTEM=="net", ACTION=="add", RUN+="/usr/sbin/ip link set can0 up"

KERNEL=="can1", SUBSYSTEM=="net", ACTION=="add", RUN+="/usr/sbin/ip link set can1 type can bitrate 500000"
KERNEL=="can1", SUBSYSTEM=="net", ACTION=="add", RUN+="/usr/sbin/ip link set can1 up"
EOF

# 重新加载 udev 规则
udevadm control --reload-rules

# 触发规则以使已有设备生效
udevadm trigger --subsystem-match=net
