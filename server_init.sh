#!/bin/bash 
# Authored by Ginkgo
# Create time 2018-02-11
# Target init Centos server

# part 1
# 初始化自己的使用环境
# 当编写脚本时， 会自动创建脚本的头部。

init_Bashenv() {
    `cp vim_header .vimrc`
}

# part2 配置ntp时间服务器，并禁用monlist 功能，方式ntp攻击 
init_Ntp() {
    `cp ntp_conf /etc/ntp.conf `
     service ntpd restart
}

# part3 修改默认端口并配置防火墙策略
# 限制同一IP 对80端口的连接次数
# 限制SYN ,RST, FIN 的连接频率和并发次数
# 允许tomcat 内部的连接

init_Firewalld() {
    `sed -i "s/#Port 22 /Port 1223/g" /etc/ssh/sshd_config`
    `iptables -A INPUT -p tcp -m tcp --dport 1223 -j ACCEPT 
     iptables -P INPUT DROP
     iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
     iptables -A INPUT -p tcp -m tcp --dport 80 -m connlimit --connlimit-above 600 --connlimit-mask 32 -j REJECT --reject-with icmp-port-unreachable
     iptables -A INPUT -i ethN -m limit --limit 1/sec --limit-burst 5 -j ACCEPT
     iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 
    `
}

add_Kernel_Rules(){
    `sed -i "$ a net.ipv4.tcp_max_syn_backlog = 4096\n net.ipv4.tcp_syncookies = 1\n net.ipv4.tcp_synack_retries = 2\n net.ipv4.tcp_syn_retries = 2\n net.ipv4.tcp_rmem = 32768\n net.ipv4.tcp_wmem = 32768\n net.ipv4.tcp_sack = 0  " /etc/sysctl.conf`
    `sysctl -p`
}


show_menus() {
cat << EOF
[Base Envirment]
1) init_Bashenv    2) init_Ntp 
3) init_Firewalld  4) add_Kernel_Rules
[Options]
[S] show menus
[Q] Exit
EOF
}

show_menus
while [[ "$index" != "Q" ]]
do 
    echo "Please input your choice: \n"
    read -p "" index
    case $index in 
    1) init_Bashenv ;;
    2) init_Ntp ;;
    3) init_Firewalld ;;
    4) add_Kernel_Rules ;;
    S) show_menus ;;
    Q) echo "exiting ...." ;;
    *) echo "Input Error";;
    esac
done

cat << EOF
-------------------------------------
   |   Thanks for your use   |
-------------------------------------
EOF
