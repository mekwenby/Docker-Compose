if [ $# -gt 0 ]
then
  MY="$1"
    echo "导入文件为：$MY"
  docker exec -i mysql8_tty_db_1 sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < $MY
else
     echo "没有指定导入文件！"
fi






