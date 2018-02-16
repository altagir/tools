PID=$(ps -ef | awk '/[m]iner/{print $2}')
echo "Mining uptime: $(ps -o etime= -p $PID)"
