#aria2 config file position
aria2_conf=/data/data/com.termux/files/home/.aria2/aria2.conf

TRACKER=$(
    curl -fsSL --connect-timeout 3 --max-time 3 --retry 2 https://trackerslist.com/best_aria2.txt ||
    curl -fsSL --connect-timeout 3 --max-time 3 --retry 2 https://cdn.jsdelivr.net/gh/XIU2/TrackersListCollection@master/best_aria2.txt ||
    curl -fsSL --connect-timeout 3 --max-time 3 --retry 2 https://trackers.p3terx.com/all_aria2.txt
)

check_pid() 
{
PID=$(pgrep "aria2c" | grep -v grep | grep -v "aria2.sh" | grep -v "service" | awk '{print $1}')
}

#Main
echo -e "\033[33m[*] Aria2开始启动… \033[0m"
check_pid
[[ -n ${PID} ]] &&echo -e "\033[31m[!] Aria2 正在运行!\033[0m" && exit

check_pid
echo -e "\033[34m[*] 正在更新BT-Tracker… \033[0m"
[ -z $(grep "bt-tracker=" ${aria2_conf}) ] && echo "bt-tracker=" >>${aria2_conf}
sed -i "s@^\(bt-tracker=\).*@\1${TRACKER}@" ${aria2_conf}  && echo -e "\033[34m[*] BT-Tracker写入成功！\033[0m"
echo -e "\033[32m[√] BT-Tracker更新完成！\033[0m"

echo -e "\033[34m[*] 正在清空Aria2 日志...\033[0m"
echo > "/data/data/com.termux/files/home/.aria2/aria2.log"
echo -e "\033[32m[√] Aria2 日志已清空 !\033[0m"

echo -e "\033[1;96m[#] 所有步骤执行完毕，开始启动... \033[0m" 
aria2c --conf-path="${aria2_conf}" -D

check_pid
[[ -z ${PID} ]] && echo -e "\033[31m[!] Aria2 启动失败，请检查日志!\033[0m" && exit

echo -e "\033[34m[*] 尝试开启唤醒锁… \033[0m"
termux-wake-lock

echo -e "\033[33m[√] 自启完毕，程序启动成功！\033[0m" 