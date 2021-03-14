#!/bin/env sh

script (){
dumpsys deviceidle whitelist +com.catchingnow.np
dumpsys deviceidle whitelist +com.notification.s
dumpsys deviceidle whitelist +cn.xiaolongonly.andpodsop
dumpsys deviceidle whitelist +rikka.appops
dumpsys deviceidle whitelist +moe.shizuku.redirectstorage
dumpsys deviceidle whitelist +com.tencent.tim
}

echo
echo -e "正在添加电池优化白名单..." && script
