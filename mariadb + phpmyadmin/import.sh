if [ $# -gt 0 ]
then
  MY="$1"
    echo "导出文件为：$MY"
  docker exec -i mariadb sh -c 'exec mariadb -uroot -p"$MYSQL_ROOT_PASSWORD"' < $MY
else
     echo "没有指定导入文件！"
fi


