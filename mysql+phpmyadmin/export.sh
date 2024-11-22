if [ $# -gt 0 ]
then
  MY="$1"
else
  timestamp=$(date +%Y%m%d%H%M%S)
  MY="$timestamp.sql"
fi

echo "导出文件为：$MY"


docker exec mysql8_tty_db_1 sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' > $MY
