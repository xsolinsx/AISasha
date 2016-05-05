while true; do
	now=$(date)
    echo "Killed AISasha $now"
    kill -9 $(pgrep telegram-cli)
    sleep 2000
done
