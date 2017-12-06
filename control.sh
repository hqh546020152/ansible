#!/bin/bash

#使用示例: ./control.sh test   netstat -lntp
#	   脚本		用户组 命令


IMPORT=$*
USER_GROUP=`echo $IMPORT | awk '{print $1}'`
COMMAND=`echo $IMPORT | cut -d ' ' -f 2-50`
cat /etc/ansible/hosts | grep $USER_GROUP &> /dev/null
[ $? -ne 0 ] && echo "ansibe不存在$USER_GROUP组,请检查" && exit 99
#[ -z $COMMAND ] && echo "接收不到命令,请重新输入" && exit 88
[ $COMMAND == $USER_GROUP ] &> /dev/null && echo "接收不到命令,请重新输入" && exit 88

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
[ ! -d $DIR/history ] && mkdir $DIR/history
[ ! -e $DIR/history/test.txt ] && touch $DIR/history/test.txt

#tee命令将命令结果打印在终端上，并存保存至文本中
ansible $USER_GROUP -m shell -a "$COMMAND" | tee ./history/test.txt


history_save(){
	DATE_TIME=`date +%Y%m%d`
	NEW_DIR=$DIR/history
	SAVE_FILE=$DIR/history/ansible_command_$DATE_TIME.txt
	[ ! -e $SAVE_FILE ] &&  touch $SAVE_FILE
	#chmod 777 $SAVE_FILE
	echo "***************************分割线***************************" >> ./history/ansible_command_$DATE_TIME.txt
	date >> $SAVE_FILE
	echo $USER_GROUP >> $SAVE_FILE
	echo $COMMAND >> $SAVE_FILE
	cat $DIR/history/test.txt >> $SAVE_FILE

}

history_save
