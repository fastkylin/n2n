#!/bin/bash

echo -e "Thie is n2n install shell program, and next you will deploy your n2n net setting"
echo -e "Let's do this "

start (){
	echo -e "Input your network card name"
	read nname
	echo -e "Input your network name"
	read name
	echo -e "Input your network password"
	read password 
	echo -e "Input your network address"
	read address
	echo -e "Input your network port"
	read port
	echo -e "Input yout type\n1.edge\n2.supernode\nDefault: edge"
	read c
	if [ c == 2 ];then
		c="supernode"
	else
		c="edge"
	fi
	echo -e "Check your profile\nnetwork card name : $nname\nname : $name\npassword : $password\naddress : $address\nport : $port\ntype : $c\n"
	echo -e "\nInput c to change profile"
	read a 
	if [ "$a" == "c" ];then
		start
	fi
}
start

if [ "$c" == "edge" ];then 
	echo -e "You need to input your supernode ip address"
	read ip
fi

if [ ! -d "/usr/lib" ];then
	mkdir /usr/lib
fi
cp libcrypto.so.10 /usr/lib

if [ ! -d "/usr/n2n" ];then
	mkdir /usr/n2n
fi

if [ "$c" == "supernode" ];then
	touch /usr/n2n/supernode.sh
	echo "/usr/n2n/supernode -l $port">/usr/n2n/supernode.sh
	cp supernode /usr/n2n/
	/usr/n2n/supernode.sh
	echo -e "start supernode"
elif [ "$c" == "edge" ];then
	touch /usr/n2n/edge.sh
	echo "/usr/n2n/edge -d $nname -c $name -k $password -a $address -l $ip:$port">/usr/n2n/edge.sh
	/usr/n2n/edge.sh
	echo -e "start edge"
fi

echo -e "\n setting crontab\n"
echo -e "Default: * * * * * /usr/n2n/$c.sh"
echo -e "\nyou can change the crontab file in /etc/cron.d/n2n.crontab\n"

touch /etc/cron.d/n2n.crontab
echo "* * * * * /usr/n2n/$c.sh">/etc/cron.d/n2n.crontab
crontab /etc/cron.d/n2n.crontab
echo -e "\ncrontab profile\n"
crontab -l

echo -e "\nfinished!\n"
ifconfig
