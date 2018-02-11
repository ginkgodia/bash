#########################################################################
# File Name: server_safe.sh
# author: Ginkgo
# mail: 907632998@qq.com
# Created Time: 2017年10月12日 星期四 15时44分07秒
#########################################################################
#!/bin/bash
#修改ssh默认端口
echo "port 2222" >>/etc/ssh/sshd_config
#echo "PermitRootLogin no" >> /etc/sshd/sshd_config
service sshd restart
#添加防火墙端口
echo "*filter
:INPUT ACCEPT [0*0]
:FORWARD ACCEPT [0*0]
:OUTPUT ACCEPT [0*0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 2222 -j ACCEPT 
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8080 -j ACCEPT 
-A INPUT -m state --state NEW -m tcp -p tcp --dport 21 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 20000:30000 -j ACCEPT 
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT 
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
" >/etc/sysconfig/iptables
service iptables restart


