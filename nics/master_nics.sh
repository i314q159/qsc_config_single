#!/usr/bin/env bash

# 左、右、球、48
static_nics=(
	"enp6s0,192.168.5.102/24"
	"enp3s0,192.168.4.102/24"
	"enp5s0,192.168.6.102/24"
	"enp4s0,192.168.2.102/24"

)

dhcp_nics=(
	"eno1"
	"enp2s0"
)

remove_nics_config() {
	nmcli -t -f NAME connection show | xargs -I {} nmcli connection delete "{}"
}
remove_nics_config

static_nics_config() {
	for item in "${static_nics[@]}"; do
		IFS=, read -r dev ip <<<"$item"
		con="static-$dev"
		nmcli con add con-name "$con" ifname "$dev" type ethernet ipv4.method manual ipv4.addresses "$ip"
		nmcli con modify "$con" connection.autoconnect yes
		nmcli con up "$con"
	done
}
static_nics_config

dhcp_nic_config() {
	for item in "${dhcp_nics[@]}"; do
		IFS=, read -r dev <<<"$item"
		con="dhcp-$dev"
		nmcli con add con-name "$con" ifname "$dev" type ethernet ipv4.method auto
		nmcli con modify "$con" connection.autoconnect yes
		nmcli con up "$con"
	done
}
dhcp_nic_config
