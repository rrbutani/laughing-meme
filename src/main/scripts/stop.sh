#!/bin/sh

function stop_mongo {
    mongod --shutdown
}

function stop_jetty {
    jetty_process=`jps | grep Main | cut -d ' ' -f1`
    kill -9 ${jetty_process}
}

stop_mongo
stop_jetty
