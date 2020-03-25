SHELL:=/bin/bash
BLAHi:=$(shell chmod +x `i root`/bin/* >/dev/null 2>&1)

terminfo:
	@conn --terminfo

default:
	@echo -e "Erich Spaker' Dev Tools. ¡Muy Bueno! Edition\nRevised $$(lsdate $$(i root)/bin $$(i root)/Makefile | head -1 | cut -d '=' -f1 )"

avail:
	@avail

select:
	@iplist --pretty --select
	@avail --status	

list:
	@echo "LIST:"
	@iplist --user | column
	@echo	
	@echo "AVAIL:"
	@iplist --avail --pretty

add:
	@ipaddtool

ssh:
	@conn --ssh
	
fs rfs ffs xfs xffs xrfs keys rkey fkey:
	@conn --$@

sshkey:
	@conn --copyid

path PATH:
	@echo "$$USER:"
	@echo $$PATH | grep --color -F -e "`i root`/bin" -e ''
	@echo -e "\nroot:"
	@sudo bash -c 'echo $$PATH' | grep --color -F -e "`i root`/bin" -e ''

serial:
	screen /dev/ttyUSB0 115200

IP=192.168.6.
DEV_MAIN=$(shell ip route get fibmatch 8.8.8.8 | grep -oP 'dev \K[^\s]*')
DEV=`cat $(TMP)`
TMP:=$(shell pidtmp $$PPID)

bbnet:
	ip addr
	choosefrom <( ip link | grep -oP '[0-9]+: \K[^\s:]*' ) > $(TMP)
	
	sudo ip link set down $(DEV)
	sudo ip addr flush dev $(DEV)
	sudo ip link set up $(DEV)
	sudo ip addr add $(IP)1 dev $(DEV)
	sudo ip route add $(IP)0/24 dev $(DEV) via $(IP)1
	
	sudo ifconfig $(DEV) $(IP)1
	sudo sysctl net.ipv4.ip_forward=1
	sudo iptables --table nat --append POSTROUTING --out-interface $(DEV_MAIN) -j MASQUERADE
	sudo iptables --append FORWARD --in-interface $(DEV) -j ACCEPT
	ssh debian@$(IP)2 'echo temppwd | sudo -S bash -c "set -x; ip route delete default; route add default gw $(IP)1 && echo "nameserver 8.8.8.8" > /etc/resolv.conf"'

chmod:
	sudo chmod +x `i root`/bin/*

test:
	dttmp
	echo $$PPID
	bash -c 'echo $$PPID'
	ps

