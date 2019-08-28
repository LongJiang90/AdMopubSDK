#!/bin/sh

#  confuse.sh
#  AdMopubSDK
#
#  Created by 蒋龙 on 2019/8/22.
#  Copyright © 2019 com.YouLoft.CQ. All rights reserved.


# 参考文章：https://www.jianshu.com/p/66bb2d45b3c2


TABLENAME=symbols
SYMBOL_DB_FILE="$PROJECT_DIR/AdMopubSDK/CodeObfuscation/symbols"
STRING_SYMBOL_FILE="$PROJECT_DIR/AdMopubSDK/CodeObfuscation/func.list"
HEAD_FILE="$PROJECT_DIR/AdMopubSDK/CodeObfuscation/codeObfuscation.h"
export LC_CTYPE=C

#维护数据库方便日后作排重
createTable()
{
echo "create table $TABLENAME(src text, des text);" | sqlite3 $SYMBOL_DB_FILE
}

insertValue()
{
echo "insert into $TABLENAME values('$1' ,'$2');" | sqlite3 $SYMBOL_DB_FILE
}

query()
{
echo "select * from $TABLENAME where src='$1';" | sqlite3 $SYMBOL_DB_FILE
}

rand()
{
min=$1
max=$(($2-$min+1))
num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
echo $(($num%$max+$min))
}

ramdomString()
{
#
strArr=("init" "And" "With" "ObjA" "ObjB" "Des" "Check" "All" "AdState" "Where" "Done" "Sucessed" "Fail")
rnd=$(rand 2 ${strArr[*]})
nameStr=''
for((i=1;i<10;i++));
do
subName=${strArr[n]}
$nameStr='${nameStr}${subName}'
echo $nameStr;
done
}

#ramdomString()
#{
#openssl rand -base64 64 | tr -cd 'a-zA-Z' |head -c 16
#}

rm -f $SYMBOL_DB_FILE
rm -f $HEAD_FILE
createTable

touch $HEAD_FILE
echo '#ifndef Demo_codeObfuscation_h
#define Demo_codeObfuscation_h' >> $HEAD_FILE
echo "//confuse string at `date`" >> $HEAD_FILE
cat "$STRING_SYMBOL_FILE" | while read -ra line; do
if [[ ! -z "$line" ]]; then
ramdom=`ramdomString`
echo $line $ramdom
insertValue $line $ramdom
echo "#define $line $ramdom" >> $HEAD_FILE
fi
done
echo "#endif" >> $HEAD_FILE


sqlite3 $SYMBOL_DB_FILE .dump
