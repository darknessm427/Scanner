#!/bin/bash
# better-cloudflare-ip

function bettercloudflareip(){
read -p "Please set the desired bandwidth size(The default minimum is 1,unit Mbps):" bandwidth
read -p "Set the number of RTT test processes(Default is 10,Up to 50):" tasknum
if [ -z "$bandwidth" ]
then
	bandwidth=1
fi
if [ $bandwidth -eq 0 ]
then
	bandwidth=1
fi
if [ -z "$tasknum" ]
then
	tasknum=10
fi
if [ $tasknum -eq 0 ]
then
	echo "The number of processes cannot be 0,Automatically set to default"
	tasknum=10
fi
if [ $tasknum -gt 50 ]
then
	echo "The maximum process limit is exceeded,Automatically set to the maximum value"
	tasknum=50
fi
speed=$[$bandwidth*128*1024]
starttime=$(date +%s)
cloudflaretest
realbandwidth=$[$max/128]
endtime=$(date +%s)
echo "Get the details from the server"
unset temp
if [ "$ips" == "ipv4" ]
then
	if [ $tls == 1 ]
	then
		temp=($(curl --resolve $domain:443:$anycast --retry 1 -s https://$domain/cdn-cgi/trace --connect-timeout 2 --max-time 3))
	else
		temp=($(curl -x $anycast:80 --retry 1 -s http://$domain/cdn-cgi/trace --connect-timeout 2 --max-time 3))
	fi
else
	if [ $tls == 1 ]
	then
		temp=($(curl --resolve $domain:443:$anycast --retry 1 -s https://$domain/cdn-cgi/trace --connect-timeout 2 --max-time 3))
	else
		temp=($(curl -x [$anycast]:80 --retry 1 -s http://$domain/cdn-cgi/trace --connect-timeout 2 --max-time 3))
	fi
fi
if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | grep colo= | wc -l) == 0 ]
then
	publicip=获取超时
	colo=获取超时
else
	publicip=$(echo ${temp[@]} | sed -e 's/ /\n/g' | grep ip= | cut -f 2- -d'=')
	colo=$(grep -w "($(echo ${temp[@]} | sed -e 's/ /\n/g' | grep colo= | cut -f 2- -d'='))" colo.txt | awk -F"-" '{print $1}')
fi
clear
echo "Preferred IP $anycast"
echo "Public IP address $publicip"
if [ $tls == 1 ]
then
	echo "Ports are supported 443 2053 2083 2087 2096 8443"
else
	echo "Ports are supported 80 8080 8880 2052 2082 2086 2095"
fi
echo "Set the bandwidth $bandwidth Mbps"
echo "Measured bandwidth $realbandwidth Mbps"
echo "Peak speed $max kB/s"
echo "Round-trip delays $avgms millisecond"
echo "Data Centers $colo"
echo "Total time $[$endtime-$starttime] second"
}

function rtthttps(){
avgms=0
n=1
for ip in `cat rtt/$1.txt`
do
	while true
	do
		if [ $n -le 3 ]
		then
			rsp=$(curl --resolve $domain:443:$ip https://$domain/cdn-cgi/trace -o /dev/null -s --connect-timeout 1 --max-time 3 -w %{time_connect}_%{http_code})
			if [ $(echo $rsp | awk -F_ '{print $2}') != 200 ]
			then
				avgms=0
				n=1
				break
			else
				avgms=$[$(echo $rsp | awk -F_ '{printf ("%d\n",$1*1000000)}')+$avgms]
				n=$[$n+1]
			fi
		else
			avgms=$[$avgms/3000]
			if [ $avgms -lt 10 ]
			then
				echo 00$avgms $ip >> rtt/$1.log
			elif [ $avgms -ge 10 ] && [ $avgms -lt 100 ]
			then
				echo 0$avgms $ip >> rtt/$1.log
			else
				echo $avgms $ip >> rtt/$1.log
			fi
			avgms=0
			n=1
			break
		fi
	done
done
rm -rf rtt/$1.txt
}

function rtthttp(){
avgms=0
n=1
for ip in `cat rtt/$1.txt`
do
	while true
	do
		if [ $n -le 3 ]
		then
			if [ $(echo $ip | grep : | wc -l) == 0 ]
			then
				rsp=$(curl -x $ip:80 http://$domain/cdn-cgi/trace -o /dev/null -s --connect-timeout 1 --max-time 3 -w %{time_connect}_%{http_code})
			else
				rsp=$(curl -x [$ip]:80 http://$domain/cdn-cgi/trace -o /dev/null -s --connect-timeout 1 --max-time 3 -w %{time_connect}_%{http_code})
			fi
			if [ $(echo $rsp | awk -F_ '{print $2}') != 200 ]
			then
				avgms=0
				n=1
				break
			else
				avgms=$[$(echo $rsp | awk -F_ '{printf ("%d\n",$1*1000000)}')+$avgms]
				n=$[$n+1]
			fi
		else
			avgms=$[$avgms/3000]
			if [ $avgms -lt 10 ]
			then
				echo 00$avgms $ip >> rtt/$1.log
			elif [ $avgms -ge 10 ] && [ $avgms -lt 100 ]
			then
				echo 0$avgms $ip >> rtt/$1.log
			else
				echo $avgms $ip >> rtt/$1.log
			fi
			avgms=0
			n=1
			break
		fi
	done
done
rm -rf rtt/$1.txt
}

function speedtesthttps(){
rm -rf log.txt speed.txt
curl --resolve $domain:443:$1 https://$domain/$file -o /dev/null --connect-timeout 1 --max-time 10 > log.txt 2>&1
cat log.txt | tr '\r' '\n' | awk '{print $NF}' | sed '1,3d;$d' | grep -v 'k\|M' >> speed.txt
for i in `cat log.txt | tr '\r' '\n' | awk '{print $NF}' | sed '1,3d;$d' | grep k | sed 's/k//g'`
do
	k=$i
	k=$[$k*1024]
	echo $k >> speed.txt
done
for i in `cat log.txt | tr '\r' '\n' | awk '{print $NF}' | sed '1,3d;$d' | grep M | sed 's/M//g'`
do
	i=$(echo | awk '{print '$i'*10 }')
	M=$i
	M=$[$M*1024*1024/10]
	echo $M >> speed.txt
done
max=0
for i in `cat speed.txt`
do
	if [ $i -ge $max ]
	then
		max=$i
	fi
done
rm -rf log.txt speed.txt
echo $max
}

function speedtesthttp(){
rm -rf log.txt speed.txt
if [ $(echo $1 | grep : | wc -l) == 0 ]
then
	curl -x $1:80 http://$domain/$file -o /dev/null --connect-timeout 1 --max-time 10 > log.txt 2>&1
else
	curl -x [$1]:80 http://$domain/$file -o /dev/null --connect-timeout 1 --max-time 10 > log.txt 2>&1
fi
cat log.txt | tr '\r' '\n' | awk '{print $NF}' | sed '1,3d;$d' | grep -v 'k\|M' >> speed.txt
for i in `cat log.txt | tr '\r' '\n' | awk '{print $NF}' | sed '1,3d;$d' | grep k | sed 's/k//g'`
do
	k=$i
	k=$[$k*1024]
	echo $k >> speed.txt
done
for i in `cat log.txt | tr '\r' '\n' | awk '{print $NF}' | sed '1,3d;$d' | grep M | sed 's/M//g'`
do
	i=$(echo | awk '{print '$i'*10 }')
	M=$i
	M=$[$M*1024*1024/10]
	echo $M >> speed.txt
done
max=0
for i in `cat speed.txt`
do
	if [ $i -ge $max ]
	then
		max=$i
	fi
done
rm -rf log.txt speed.txt
echo $max
}

function cloudflaretest(){
while true
do
	while true
	do
		rm -rf rtt rtt.txt log.txt speed.txt
		mkdir rtt
		echo "正在生成 $ips"
		unset temp
		if [ "$ips" == "ipv4" ]
		then
			n=0
			iplist=100
			while true
			do
				for i in `awk 'BEGIN{srand()} {print rand()"\t"$0}' $filename | sort -n | awk '{print $2} NR=='$iplist' {exit}' | awk -F\. '{print $1"."$2"."$3}'`
				do
					temp[$n]=$(echo $i.$(($RANDOM%256)))
					n=$[$n+1]
				done
				if [ $n -ge $iplist ]
				then
					break
				fi
			done
			while true
			do
				if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
				then
					break
				else
					for i in `awk 'BEGIN{srand()} {print rand()"\t"$0}' $filename | sort -n | awk '{print $2} NR=='$[$iplist-$(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l)]' {exit}' | awk -F\. '{print $1"."$2"."$3}'`
					do
						temp[$n]=$(echo $i.$(($RANDOM%256)))
						n=$[$n+1]
					done
				fi
			done
		else
			n=0
			iplist=100
			while true
			do
				for i in `awk 'BEGIN{srand()} {print rand()"\t"$0}' $filename | sort -n | awk '{print $2} NR=='$iplist' {exit}' | awk -F: '{print $1":"$2":"$3}'`
				do
					temp[$n]=$(echo $i:$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))))
					n=$[$n+1]
				done
				if [ $n -ge $iplist ]
				then
					break
				fi
			done
			while true
			do
				if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]
				then
					break
				else
					for i in `awk 'BEGIN{srand()} {print rand()"\t"$0}' $filename | sort -n | awk '{print $2} NR=='$[$iplist-$(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l)]' {exit}' | awk -F: '{print $1":"$2":"$3}'`
					do
						temp[$n]=$(echo $i:$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))):$(printf '%x\n' $(($RANDOM*2+$RANDOM%2))))
						n=$[$n+1]
					done
				fi
			done
		fi
		ipnum=$(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l)
		if [ $tasknum == 0 ]
		then
			tasknum=1
		fi
		if [ $ipnum -lt $tasknum ]
		then
			tasknum=$ipnum
		fi
		n=1
		for i in `echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u`
		do
			echo $i>>rtt/$n.txt
			if [ $n == $tasknum ]
			then
				n=1
			else
				n=$[$n+1]
			fi
		done
		n=1
		while true
		do
			if [ $tls == 1 ]
			then
				rtthttps $n &
			else
				rtthttp $n &
			fi
			if [ $n == $tasknum ]
			then
				break
			else
				n=$[$n+1]
			fi
		done
		while true
		do
			n=$(ls rtt | grep txt | wc -l)
			if [ $n -ne 0 ]
			then
				echo "$(date +'%H:%M:%S') Wait for the RTT test to end,The number of processes remaining $n"
			else
				echo "$(date +'%H:%M:%S') RTT testing completed"
				break
			fi
			sleep 1
		done
		n=$(ls rtt | grep log | wc -l)
		if [ $n == 0 ]
		then
			echo "Currently, all IPs have RTT packet loss"
			echo "Continue with new RTT tests"
		else
			cat rtt/*.log > rtt.txt
			status=0
			echo "The IP address of the speed test"
			cat rtt.txt | sort | awk '{print $2" Round-trip delays "$1" millisecond"}'
			for i in `cat rtt.txt | sort | awk '{print $1"_"$2}'`
			do
				avgms=$(echo $i | awk -F_ '{print $1}')
				ip=$(echo $i | awk -F_ '{print $2}')
				echo "Testing $ip"
				if [ $tls == 1 ]
				then
					max=$(speedtesthttps $ip)
				else
					max=$(speedtesthttp $ip)
				fi
				if [ $max -ge $speed ]
				then
					status=1
					anycast=$ip
					max=$[$max/1024]
					echo "$ip Peak speed $max kB/s"
					rm -rf rtt rtt.txt
					break
				else
				max=$[$max/1024]
				echo "$ip Peak speed $max kB/s"
				fi
			done
			if [ $status == 1 ]
			then
				break
			fi
		fi
	done
		break
done
}

function singlehttps(){
read -p "Please enter the IP address for which you want to test the speed: " ip
read -p "Please enter the port where you want to test the speed(Default is 443): " port
if [ -z "$ip" ]
then
	echo "IP is not entered"
fi
if [ -z "$port" ]
then
	port=443
fi
echo "正在测速 $ip 端口 $port"
speed_download=$(curl --resolve $domain:$port:$ip https://$domain:$port/$file -o /dev/null --connect-timeout 5 --max-time 15 -w %{speed_download} | awk -F\. '{printf ("%d\n",$1/1024)}')
}

function singlehttp(){
read -p "Please enter the IP address for which you want to test the speed: " ip
read -p "Please enter the port where you want to test the speed(Default is 80): " port
if [ -z "$ip" ]
then
	echo "IP is not entered"
fi
if [ -z "$port" ]
then
	port=80
fi
echo "Speed test in progress $ip port $port"
if [ $(echo $ip | grep : | wc -l) == 0 ]
then
	speed_download=$(curl -x $ip:$port http://$domain:$port/$file -o /dev/null --connect-timeout 5 --max-time 15 -w %{speed_download} | awk -F\. '{printf ("%d\n",$1/1024)}')
else
	speed_download=$(curl -x [$ip]:$port http://$domain:$port/$file -o /dev/null --connect-timeout 5 --max-time 15 -w %{speed_download} | awk -F\. '{printf ("%d\n",$1/1024)}')
fi
}

function datacheck(){
clear
echo "If these files below fail to download,You can manually access the URL to download and save to the peer directory"
echo "https://www.baipiao.eu.org/cloudflare/colo Save As colo.txt"
echo "https://www.baipiao.eu.org/cloudflare/url Save As url.txt"
echo "https://www.baipiao.eu.org/cloudflare/ips-v4 Save As ips-v4.txt"
echo "https://www.baipiao.eu.org/cloudflare/ips-v6 Save As ips-v6.txt"
while true
do
	if [ ! -f "colo.txt" ]
	then
		echo "Download data center information from the server colo.txt"
		curl --retry 2 -s https://www.baipiao.eu.org/cloudflare/colo -o colo.txt
	elif [ ! -f "url.txt" ]
	then
		echo "Download the address of the speed test file from the server url.txt"
		curl --retry 2 -s https://www.baipiao.eu.org/cloudflare/url -o url.txt
	elif [ ! -f "ips-v4.txt" ]
	then
		echo "DOWNLOAD IPV4 DATA FROM THE SERVER ips-v4.txt"
		curl --retry 2 -s https://www.baipiao.eu.org/cloudflare/ips-v4 -o ips-v4.txt
	elif [ ! -f "ips-v6.txt" ]
	then
		echo "DOWNLOAD IPV6 DATA FROM THE SERVER ips-v6.txt"
		curl --retry 2 -s https://www.baipiao.eu.org/cloudflare/ips-v6 -o ips-v6.txt
	else
		break
	fi
done
}
datacheck
url=$(sed -n '1p' url.txt)
domain=$(echo $url | cut -f 1 -d'/')
file=$(echo $url | cut -f 2- -d'/')
clear
while true
do
	echo "1. IPV4优选(TLS)"
	echo "2. IPV4优选"
	echo "3. IPV6优选(TLS)"
	echo "4. IPV6优选"
	echo "5. 单IP测速(TLS)"
	echo "6. 单IP测速"
	echo "7. 清空缓存"
	echo "8. 更新数据"
	echo -e "0. 退出\n"
	read -p "请选择菜单(默认0): " menu
	if [ -z "$menu" ]
	then
		menu=0
	fi
	if [ $menu == 0 ]
	then
		clear
		echo "退出成功"
		break
	fi
	if [ $menu == 1 ]
	then
		ips=ipv4
		filename=ips-v4.txt
		tls=1
		bettercloudflareip
		break
	fi
	if [ $menu == 2 ]
	then
		ips=ipv4
		filename=ips-v4.txt
		tls=0
		bettercloudflareip
		break
	fi
	if [ $menu == 3 ]
	then
		ips=ipv6
		filename=ips-v6.txt
		tls=1
		bettercloudflareip
		break
	fi
	if [ $menu == 4 ]
	then
		ips=ipv6
		filename=ips-v6.txt
		tls=0
		bettercloudflareip
		break
	fi
	if [ $menu == 5 ]
	then
		singlehttps
		clear
		echo "$ip 平均速度 $speed_download kB/s"
	fi
	if [ $menu == 6 ]
	then
		singlehttp
		clear
		echo "$ip 平均速度 $speed_download kB/s"
	fi
	if [ $menu == 7 ]
	then
		rm -rf rtt rtt.txt log.txt speed.txt
		clear
		echo "缓存已经清空"
	fi
	if [ $menu == 8 ]
	then
		rm -rf colo.txt url.txt ips-v4.txt ips-v6.txt
		datacheck
		clear
	fi
done
