#!/bin/bash
set -e #to make sure errors are never silenced

ARCH=$(uname --all)
PHYSCPU=$(lscpu | grep --max-count=1 'CPU(s)' | grep --extended-regexp --only-matching '[0-9]')
VCPU=$(grep --count 'processor' /proc/cpuinfo)
MEMUSAGE=$(free --mega | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3, $2, $3/$2*100}')
#USEDDISK=$(df -m | grep /dev/ | awk '{used+=$3;}END{print used;}')
#TOTALDISK=$(df -BG | grep /dev/ | awk '{total+=$4}END{print total;}')
DISKPERCENT=$(df -Bm | grep /dev/ | awk '{used += $3; total += $4;} END {printf "%d/%dGb (%d%%)", used, total/1000, used/total*100}')
#DISKPERCENT=$(df -Bm | grep /dev/ | awk '{used += $3; total += $4;} END {
#				OFMT = "%.0f"  # to format the output of print 
#				print used/total*100}')
#DISKUSAGE={printf "%s/%sGB (%d%%)", $USEDDISK, $TOTALDISK, $USEDDISK/1024/$TOTALDISK*100}
CPU_LOAD=$(top -bn1 | grep '%Cpu(s)' | awk '{used = $2 + $4;} END {printf "%.1f%%", used}')
LAST_BOOT=$(who -b | awk '{printf "%s %s", $3, $4}')
LVM_USE=$(lsblk --output TYPE | grep -c lvm | \
	awk '{ if ($1) {
			print "yes"
		} 
		else {
			print "no"
		}
	}')
NB_TCP=$(netstat -t | grep ESTABLISHED | wc -l | awk '{print $1 " ESTABLISHED";}') 
NB_USERS=$(who | wc -l)
IPV4_ADDR=$(hostname -I | awk '{print "IP " $1;}')
MAC_ADDR=$(ip a | awk '$1 == "link/ether" {print $2;}')
NB_SUDO=$(journalctl _COMM=sudo | grep COMMAND | wc -l | awk '{print $1 " cmd";}')

wall "	#Architecture: $ARCH
	#CPU physical : $PHYSCPU
	#vCPU : $VCPU
	#Memory Usage: $MEMUSAGE
	#Disk Usage: $DISKPERCENT
	#CPU load: $CPU_LOAD
	#Last boot: $LAST_BOOT
	#LVM Use: $LVM_USE
	#Connexions TCP : $NB_TCP
	#User log: $NB_USERS
	#Network: $IPV4_ADDR ($MAC_ADDR)
	#Sudo : $NB_SUDO
	" 
