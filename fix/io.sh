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

# can0
# ip link set can0 type can bitrate 500000 listen-only on
# ip link set can0 up
cat >/etc/udev/rules.d/80-can.rules <<EOF
KERNEL=="can0", SUBSYSTEM=="net", ACTION=="add", RUN+="/usr/sbin/ip link set can0 type can bitrate 500000"
KERNEL=="can0", SUBSYSTEM=="net", ACTION=="add", RUN+="/usr/sbin/ip link set can0 up"
EOF

# 验证 can0
# ip -d link show can0
# state UP
# bitrate 500000

# 重新加载 udev 规则
udevadm control --reload-rules

# 触发规则以使已有设备生效
udevadm trigger
