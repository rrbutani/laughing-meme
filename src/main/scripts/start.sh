#!/bin/sh
source stop.sh

function install_war {
    mkdir www
    cd www
    jar xf ../$1
}

war=$1
export war

if [ ! -d www ]
then
    echo "installing $war"
    install_war $war
else
    eval $(stat -s www)
    www_mod=$st_mtime
    eval $(stat -s $war)
    war_mod=$st_mtime
    if [ $war_mod -gt $www_mod ]
    then
        echo "re-installing $war"
        rm -rf www
        install_war $war
    else
        echo "www and $war are up to date"
        cd www
    fi
fi
CP="WEB-INF/classes"
for entry in WEB-INF/lib/*.jar
do 
    CP=$CP:$entry
done

# run mongod
# todo: check if it is already running and then kill it and then run it
stop_jetty
stop_mongo
# todo: run it on a different port so we can see it from the browser, or ask vadim to open port 27017
mongod &

date=`date "+%m-%d-%Y-%H-%M-%S"`
log_file="/home/rahul/logs/${date}.log"
# log_file="/home/robotics/logs/${date}.log"
touch $log_file
echo "creating log_file in $log_file"
java -cp "$CP" com.hshacks.fra.Main production > ${log_file} &