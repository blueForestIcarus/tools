SHELL:=/bin/bash
BLAHi:=$(shell chmod +x `i root`/bin/* >/dev/null 2>&1)
MRE=$(shell lsdate $$(i root)/bin $$(i root)/util/Makefile | head -1 | cut -d '=' -f2)#

default:
	@echo -e "Erich Spaker's Dev Tools. ¡Muy Bueno! Edition\nRevised $$(ago -f "$(MRE)") :: \e[2m$$(realpath -s -m --relative-to="`i root`" "`trim $(MRE)`")\e[22m"

perms:
	sudo chown -R $$USER `i root`/bin
	sudo chmod -R +x `i root`/bin/*

terminfo:
	@conn --terminfo

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

fix:
	@conn --fix
	
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
	test ! -e /dev/ttyUSB0 || sudo screen /dev/ttyUSB0 115200
	test ! -e /dev/ttyUSB1 || sudo screen /dev/ttyUSB1 115200

ignore:
	cd `i root` && git submodule | cut -d ' ' -f3 | sed 's/$$/\/\*/g' > .ignore
	cd `i root` && test ! -d data || echo data/* >> .ignore

IP=192.168.6.
DEV_MAIN=$(shell ip route get fibmatch 8.8.8.8 | grep -oP 'dev \K[^\s]*')
DEV=`cat $(TMP)`
TMP:=$(shell pidtmp $$PPID)

bbnet_:
	ip addr
	choosefrom --skip <( ip link | grep -oP '[0-9]+: \K[^\s:]*' | grep -v lo  | grep -v $(DEV_MAIN)) > $(TMP)
	
	sudo ip link set down $(DEV)
	sudo ip addr flush dev $(DEV)
	sudo ip link set up $(DEV)
	sudo ip addr add $(IP)1 dev $(DEV)
	sudo ip route add $(IP)0/24 dev $(DEV) via $(IP)1

bbnet: bbnet_
	#sudo ifconfig $(DEV) $(IP)1
	sudo sysctl net.ipv4.ip_forward=1
	sudo iptables --table nat --append POSTROUTING --out-interface $(DEV_MAIN) -j MASQUERADE
	sudo iptables --append FORWARD --in-interface $(DEV) -j ACCEPT
	ssh-keygen -R $(IP)2
	ssh-keyscan -H $(IP)2 >> ~/.ssh/known_hosts
	sshpass -p temppwd ssh -o StrictHostKeyChecking=no debian@$(IP)2 'echo temppwd | sudo -S bash -c "set -x; ip route delete default; route add default gw $(IP)1 && echo 'nameserver 8.8.8.8' > /etc/resolv.conf"'

DT=$(MAKE) -f `i root`/util/Makefile
bbnet8_:
	$(DT) bbnet_ IP=192.168.8.

bbnet6_:
	$(DT) bbnet_ IP=192.168.6.

bbnet7_:
	$(DT) bbnet_ IP=192.168.7.

bbnet8:
	$(DT) bbnet IP=192.168.8.

bbnet6:
	$(DT) bbnet IP=192.168.6.

bbnet7:
	$(DT) bbnet IP=192.168.7.

chmod:
	sudo chmod +x `i root`/bin/*

test:
	dttmp
	echo $$PPID
	bash -c 'echo $$PPID'
	ps

reboot_emmc:
	test "`iplist --active --ip`" = "192.168.8.2" || yesno -N "reboot `iplist --active`?" 
	conn -c 'set -e ; set -x; test "`uname -m`" = "armv7l" && test -f "/boot/uEnv.emmc.txt" && sudo ln -snfT uEnv.emmc.txt /boot/uEnv.txt && sudo reboot'

reboot_main:
	test "`iplist --active --ip`" = "192.168.8.2" || yesno -N "reboot `iplist --active`?" 
	conn -c 'set -e ; set -x; test "`uname -m`" = "armv7l" && test -f "/boot/uEnv.main.txt" && sudo ln -snfT uEnv.main.txt /boot/uEnv.txt && sudo reboot' 
