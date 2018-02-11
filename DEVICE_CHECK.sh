#!/bin/bash 
ISINSTALLED_D=$(rpm -qa |grep dmidecode)
#if [ -z $ISINSTALLED_D ];then
#   yum install -y dmidecode
#fi

NUM=$1
NUM=${NUM:=0}
ISSHOW_DES=$2
ISSHOW_DES=${ISSHOW_DES:=0}

U_NUM=$(dmidecode -t chassis |grep Height:|cut -d : -f 2)
U_NUM=${U_NUM// /}
PRODUCT=$(dmidecode -t system |grep Product|cut -d : -f 2 |sed -e 's/^[ \t]*//' )
SERIAL=$(dmidecode -t system |grep Serial |cut -d : -f 2 |sed -e 's/^[ \t]*//')
MEM_MAX_CAPACITY=$(dmidecode -t memory|grep "Maximum Capacity"|cut -d : -f 2)
MEM_MAX_CAPACITY=${MEM_MAX_CAPACITY// /}
MEM_NUM_OF_DEV=$(dmidecode -t memory|grep "Number Of Devices"|cut -d : -f 2)
MEM_NUM_OF_DEV=${MEM_NUM_OF_DEV// /}
MEM_NUM_OF_DEV_USED=$(dmidecode -t memory|grep "Speed: Unknown"|wc -l)
MEM_NUM_OF_DEV_USED=$(($MEM_NUM_OF_DEV - $MEM_NUM_OF_DEV_USED))
MEM_TYPE=$(dmidecode -t memory|grep "Type: "|tail -1|cut -d : -f 2)
MEM_TYPE=${MEM_TYPE// /}
CPU=$(cat /proc/cpuinfo |grep CPU|head -1|cut -d : -f 2 | sed -e 's/^[ \t]*//')
CPU=${CPU// /}
CPU=${CPU//@/ }
CPU_NUM=$(cat /proc/cpuinfo |grep CPU|wc -l)
CPU_INFO="$CPU * $CPU_NUM"
if [ "${ISSHOW_DES}0" != "10" ]; then
  echo "|ID|服务器名|服务器型号|U数|DELL序列号|内存数|最大内存|总内存槽数|已经内存槽数|内存类型|硬盘大小信息|CPU 信息汇总|"
  echo "|--|------|--------|---|---------|-----|------|---------|----------|------|----------|----------|"
fi
  echo "|$NUM|$HOSTNAME|$PRODUCT|$U_NUM|$SERIAL|$MEM|$MEM_MAX_CAPACITY|$MEM_NUM_OF_DEV|$MEM_NUM_OF_DEV_USED|$MEM_TYPE|$DISK_SIZE|$CPU_INFO|"
