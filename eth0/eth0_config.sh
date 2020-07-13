#!/bin/bash
TEST_IP=192.168.4.2
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root (use sudo)" 1>&2
	exit 1
fi
LINK_STATUS=`dmesg | grep eth0 | tail -n 1 | awk '{print $8}'`
echo $LINK_STATUS
if [ $LINK_STATUS = "ready" ]
then
	ping -c 5 $TEST_IP
	exit 1
fi
#LAN8710A disable Auto-Negotiation
/debian/home/aurora_test/eth0/phytool write eth0/0/0x0 0x000 
/debian/home/aurora_test/eth0/phytool read eth0/0/0x0      
# LAN8710A disable AUTO-MDIX
/debian/home/aurora_test/eth0/phytool write eth0/0/0x1b 0xa00b 
/debian/home/aurora_test/eth0/phytool read eth0/0/0x1b      

sleep 10
#LAN8710A enable 100M
/debian/home/aurora_test/eth0/phytool write eth0/0/0x0 0x2100
/debian/home/aurora_test/eth0/phytool read eth0/0/0x0
ping -c 5 $TEST_IP
