#!/bin/bash

#bash <(curl -s -L https://raw.githubusercontent.com/735840086/SocatProxy/main/install.sh)
#bash <(curl -s -L -k https://raw.githubusercontent.com/735840086/SocatProxy/main/install.sh)
#bash <(curl -s -L -k https://raw.githubusercontent.com/735840086/SocatProxy/main/install.sh)
#bash <(curl -s -L -k https://raw.githubusercontent.com/735840086/SocatProxy/main/install.sh)
clear

[ $(id -u) != "0" ] && { echo "ROOT权限安装"; exit 1; }

IS_OPENWRT=false

# Check for SocatProxy
if [ -f /etc/SocatProxy_version ]; then
    IS_OPENWRT=true
fi


if [ "$IS_SocatProxy" = true ]; then
    echo "This is an SocatProxy system."
else
    if command -v systemctl &> /dev/null; then
        echo "check systemctl..."
        clear
    else
        echo "系统不支持systemctl, 需安装systemctl."
        exit 1;
    fi
fi

SERVICE_NAME="SocatProxyervice"

PATH_RMS="/root/SocatProxy"
PATH_EXEC="SocatProxy"
PATH_NOHUP="${PATH_RMS}/nohup.out"
PATH_ERR="${PATH_RMS}/err.log"

ROUTE_1="https://raw.githubusercontent.com/735840086/hhminer/main/SocatProxy"
ROUTE_2="http://SocatProxysystem.com"
# ROUTE_2="https://raw.githubusercontent.com/735840086/hhminer/main"
# ROUTE_3="https://raw.githubusercontent.com/735840086/hhminer/main"
# ROUTE_4="https://raw.githubusercontent.com/735840086/hhminer/main"

ROUTE_EXEC_1="https://raw.githubusercontent.com/735840086/hhminer/main/SocatProxy"
ROUTE_EXEC_2="/EvilGenius-dot/RMS/raw/main/x86_64-android/rms"
ROUTE_EXEC_3="/EvilGenius-dot/RMS/raw/main/arm-musleabi/rms"
ROUTE_EXEC_4="/EvilGenius-dot/RMS/raw/main/arm-musleabihf/rms"
ROUTE_EXEC_5="/EvilGenius-dot/RMS/raw/main/armv7-musleabi/rms"
ROUTE_EXEC_6="/EvilGenius-dot/RMS/raw/main/armv7-musleabihf/rms"
ROUTE_EXEC_7="/EvilGenius-dot/RMS/raw/main/i586-musl/rms"
ROUTE_EXEC_8="/EvilGenius-dot/RMS/raw/main/i686-android/rms"
ROUTE_EXEC_9="/EvilGenius-dot/RMS/raw/main/aarch64-musl/rms"

TARGET_ROUTE=""
TARGET_ROUTE_EXEC=""

UNAME=`uname -m`

filterResult() {
    if [ $1 -eq 0 ]; then
        echo ""
    else
        echo "!!!!!!!!!!!!!!!ERROR!!!!!!!!!!!!!!!!"
        echo "【${2}】失败。"
	
        if [ ! $3 ];then
            echo "!!!!!!!!!!!!!!!ERROR!!!!!!!!!!!!!!!!"
            exit 1
        fi
    fi
    echo -e
}

disable_firewall() {
    os_name=$(grep "^ID=" /etc/os-release | cut -d "=" -f 2 | tr -d '"')
    echo "关闭防火墙"

    if [ "$os_name" == "ubuntu" ]; then
        sudo ufw disable
    elif [ "$os_name" == "centos" ]; then
        sudo systemctl stop firewalld
        sudo systemctl disable firewalld
    else
        echo "未知系统, 关闭防火墙失败"
    fi
}

check_process() {
    if [ "$IS_SocatProxy" = true ]; then
        if pgrep -f "$1" >/dev/null; then
            return 0
        else
            return 1
        fi
    else
        if [[ $(uname) == "Linux" ]]; then
            if pgrep -x "$1" >/dev/null; then
                return 0
            else
                return 1
            fi
        else
            if ps aux | grep -v grep | grep "$1" >/dev/null; then
                return 0
            else
                return 1
            fi
        fi
    fi
}

# 设置开机启动
#!/bin/sh

# Function to set up auto-start and start the program
wrt_enable_autostart() {
    echo "wrt_set_start"
    if [ ! -f /etc/init.d/SocatProxy ]; then
        # Create an init script for the "SocatProxy" service
        echo "#!/bin/sh /etc/rc.common" > /etc/init.d/SocatProxy
        echo "USE_PROCD=1" >> /etc/init.d/SocatProxy
        echo "START=99" >> /etc/init.d/SocatProxy
        echo "start() {" >> /etc/init.d/SocatProxy
        echo "    /root/SocatProxy/SocatProxy &" >> /etc/init.d/SocatProxy
        echo "}" >> /etc/init.d/SocatProxy
        
        echo "PROG=/root/SocatProxy/SocatProxy" >> /etc/init.d/SocatProxy
        echo "start_service(){" >> /etc/init.d/SocatProxy
        echo "  procd_open_instance" >> /etc/init.d/SocatProxy
        echo "  procd_set_param command \$PROG" >> /etc/init.d/SocatProxy
        echo "  procd_set_param respawn" >> /etc/init.d/SocatProxy
        echo "  procd_close_instance" >> /etc/init.d/SocatProxy
        echo "}" >> /etc/init.d/SocatProxy

        chmod +x /etc/init.d/SocatProxy
    fi

    /etc/init.d/SocatProxy enable
    /etc/init.d/SocatProxy start
}

# Function to stop auto-start and stop the program
wrt_disable_autostart() {
    echo "wrt_set_disable"
    if [ -f /etc/init.d/SocatProxy ]; then
        # Stop the "SocatProxy" service
        /etc/init.d/SocatProxy stop

        # Remove the init script
        rm /etc/init.d/SocatProxy
    fi
}


# 开机启动且进程守护
enable_autostart() {
    echo "${m_14}"
    if [ "$(command -v systemctl)" ]; then
        sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null <<EOF
[Unit]
Description=My Program
After=network.target

[Service]
Type=simple
ExecStart=$PATH_RMS/$PATH_EXEC
WorkingDirectory=$PATH_RMS/
Restart=always
StandardOutput=file:$PATH_SocatProxy/nohup.out
StandardError=file:$PATH_SocatProxy/err.log
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF
        sudo systemctl daemon-reload
        sudo systemctl enable $SERVICE_NAME.service
        sudo systemctl start $SERVICE_NAME.service
    else
        sudo sh -c "echo '${PATH_RMS}/${PATH_EXEC} &' >> /etc/rc.local"
        sudo chmod +x /etc/rc.local
    fi
}

# 禁用开机启动函数
disable_autostart() {
    echo "关闭开机启动..."
    if [ "$(command -v systemctl)" ]; then
        sudo systemctl stop $SERVICE_NAME.service
        sudo systemctl disable $SERVICE_NAME.service
        sudo rm /etc/systemd/system/$SERVICE_NAME.service
        sudo systemctl daemon-reload
    else # 系统SysVinit
        sudo sed -i '/\/root\/SocatProxysystem\/SocatProxysystem\ &/d' /etc/rc.local
    fi

    sleep 1
}

kill_process() {
    if [ "$IS_OPENWRT" = true ]; then
        local process_name="$1"
        local pids=($(pgrep -f "$process_name"))
        echo "WRT KILL IPD $pids"
        if kill -9 "$pids" >/dev/null 2>&1; then
            echo "已终止 $pids 进程."
        else
            echo "未发现 $pids 进程."
            return 1
        fi
    else
        local process_name="$1"
        local pids=($(pgrep "$process_name"))
        
        if [ ${#pids[@]} -eq 0 ]; then
            echo "未发现 $process_name 进程."
            return 1
        fi
        for pid in "${pids[@]}"; do
            echo "Stopping process $pid ..."
            kill -TERM "$pid"
        done
        echo "终止 $process_name ."
    fi

    sleep 1
}

change_limit() {
    echo "${m_18}"

    changeLimit="n"

    if [[ -f /etc/debian_version ]]; then
    echo "soft nofile 65535" | sudo tee -a /etc/security/limits.conf
    echo "hard nofile 65535" | sudo tee -a /etc/security/limits.conf
    echo "fs.file-max = 100000" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p

    # add PAM configuration to enable the limits for login sessions
    if [[ -f /etc/pam.d/common-session ]]; then
        grep -q '^session.*pam_limits.so$' /etc/pam.d/common-session || sudo sh -c "echo 'session required pam_limits.so' >> /etc/pam.d/common-session"
        fi
    fi

    # set file descriptor limits for CentOS/RHEL
    if [[ -f /etc/redhat-release ]]; then
        echo "* soft nofile 65535" | sudo tee -a /etc/security/limits.conf
        echo "* hard nofile 65535" | sudo tee -a /etc/security/limits.conf
        echo "fs.file-max = 100000" | sudo tee -a /etc/sysctl.conf
        sudo sysctl -p
    fi

    # set file descriptor limits for macOS
    if [[ "$(uname)" == "Darwin" ]]; then
        sudo launchctl limit maxfiles 65535 65535
        sudo sysctl -w kern.maxfiles=100000
        sudo sysctl -w kern.maxfilesperproc=65535
    fi

    # set systemd file descriptor limits
    if [[ -x /bin/systemctl ]]; then
        echo "DefaultLimitNOFILE=65535" >>/etc/systemd/user.conf
        echo "DefaultLimitNOFILE=65535" >>/etc/systemd/system.conf
        systemctl daemon-reexec
    fi

    if [ $(grep -c "root soft nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root soft nofile 65535" >>/etc/security/limits.conf
        echo "* soft nofile 65535" >>/etc/security/limits.conf
        changeLimit="y"
    fi

    if [ $(grep -c "root hard nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root hard nofile 65535" >>/etc/security/limits.conf
        echo "* hard nofile 65535" >>/etc/security/limits.conf
        changeLimit="y"
    fi

    if [ $(grep -c "DefaultLimitNOFILE=65535" /etc/systemd/user.conf) -eq '0' ]; then
        echo "DefaultLimitNOFILE=65535" >>/etc/systemd/user.conf
        changeLimit="y"
    fi

    if [ $(grep -c "DefaultLimitNOFILE=65535" /etc/systemd/system.conf) -eq '0' ]; then
        echo "DefaultLimitNOFILE=65535" >>/etc/systemd/system.conf
        changeLimit="y"
    fi

    if [[ "$changeLimit" = "y" ]]; then
        echo "连接限制为65535,重启生效"
    else
        echo -n "连接限制："
        ulimit -n
    fi

    echo "完成, 重启生效"
}

install() {
    if [ -f /etc/centos-release ] || \
    ([ -f /etc/lsb-release ] && . /etc/lsb-release && [ "$DISTRIB_ID" = "Ubuntu" ]) || \
    [ -f /etc/SocatProxy_version ]; then
        echo "CENTOS || UBUNTU || OPENWRT"
    else
        # 命令
        chown root:root /mnt -R
        chown root:root /etc -R
        chown root:root /usr -R
        chown man:root /var/cache/man -R
        chmod g+s /var/cache/man -R
    fi

    disable_firewall

    check_process $PATH_EXEC

    if [ $? -eq 0 ]; then
        echo "正在运行${PATH_EXEC}需停止可安装。"
        echo "输入1停止${PATH_EXEC}且继续安装, 输入2取消安装。"

        read -p "$(echo -e "选择[1-2]：")" choose
        case $choose in
        1)
            stop
            ;;
        2)
            echo "取消安装"
            return
            ;;
        *)
            echo "输入错误, 取消安装。"
            return
            ;;
        esac
    fi

    if [[ ! -d $PATH_SocatProxy ]];then
        mkdir $PATH_SocatProxy
        chmod 777 -R $PATH_SocatProxy
    else
        echo "目录存在, 无需创建, 继续安装。"
    fi

    if [[ ! -d $PATH_NOHUP ]];then
        touch $PATH_NOHUP
        touch $PATH_ERR

        chmod 777 -R $PATH_NOHUP
        chmod 777 -R $PATH_ERR
    fi

    echo "开始下载程序..."

    wget -P $PATH_RMS "${TARGET_ROUTE}${TARGET_ROUTE_EXEC}" -O "${PATH_RMS}/${PATH_EXEC}" 1>/dev/null

    filterResult $? "下载程序"

    chmod 777 -R "${PATH_RMS}/${PATH_EXEC}"

    change_limit

    start
}

restart() {
    stop

    start
}

uninstall() {
    stop

    rm -rf ${PATH_SocatProxy}

    if [ "$IS_SocatProxy" = true ]; then
        wrt_disable_autostart
    else
        disable_autostart
    fi

    echo "卸载完成"
}

start() {
    echo $BLUE "启动程序..."
    check_process $PATH_EXEC

    if [ $? -eq 0 ]; then
        echo "程序已启动，请勿重复启动。"
        return
    else
        # cd $PATH_SocatProxy

        # nohup "${PATH_SocatProxy}/${PATH_EXEC}" 2>$PATH_ERR &

        if [ "$IS_SocatProxy" = true ]; then
            wrt_enable_autostart
        else
            enable_autostart
        fi

        sleep 1

        check_process $PATH_EXEC

        if [ $? -eq 0 ]; then
            echo "|----------------------------------------------------------------|"
            echo "启动成功, 地址IP:42703"
            echo "|----------------------------------------------------------------|"
        else
            echo "启动失败!!!"
        fi
    fi
}

stop() {
    sleep 1

    if [ "$IS_SocatProxy" = true ]; then
        wrt_disable_autostart
    else
        disable_autostart
    fi

    sleep 1

    echo "终止进程..."

    kill_process $PATH_EXEC

    sleep 1
}

echo "------ SocatProxy ------"
echo "1. 安装"
echo "2. 停止"
echo "3. 重启"
echo "4. 卸载"
echo "---------------------"

read -p "$(echo -e "[1-4]：")" comm

if [ "$comm" = "1" ]; then
    clear
elif [ "$comm" = "2" ]; then
    stop
    exit 1
elif [ "$comm" = "3" ]; then
    restart
    exit 1
elif [ "$comm" = "4" ]; then
    uninstall
    exit 1
fi


echo "------ SocatProxy ------"
echo "当前CPU架构【${UNAME}】"
echo 开始架构安装。
echo "---------------------"
echo "1. 开始安装"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo ""

read -p "$(echo -e "[-]：")" targetExec

VARNAME="ROUTE_EXEC_${targetExec}"
TARGET_ROUTE_EXEC="${!VARNAME}"

clear

echo "------ SocatProxy ------"
echo "开始下载安装:"
echo "1. 开始下载"
echo "⭐️⭐️⭐️⭐️⭐️⭐️"
# echo "⭐️⭐️⭐️⭐️⭐️⭐️"
# echo "⭐️⭐️⭐️⭐️⭐️⭐️"
echo "---------------------"

read -p "$(echo -e "[-]：")" targetRoute

VARNAME="ROUTE_${targetRoute}"
TARGET_ROUTE="${!VARNAME}"

[ ! $TARGET_ROUTE ] && { echo "错误"; exit 1; }
[ ! $TARGET_ROUTE_EXEC ] && { echo "错误"; exit 1; }

echo "${TARGET_ROUTE}${TARGET_ROUTE_EXEC}"

install
