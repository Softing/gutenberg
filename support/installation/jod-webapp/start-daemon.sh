#!/bin/sh

PID_FILE=/var/run/inprint-converter.pid

export INPRINT_CONVERTER_HOME=/root/jod-webapp

case "$1" in
    start)
        cd ${INPRINT_CONVERTER_HOME} || exit
        java -Xmx256m -Xms256m -jar jetty-runner-7.2.0.v20101020.jar --port 9999 --log daemon.log softing-filebackend-service-1.3.war &
        echo $! > $PID_FILE
        ;;
    stop)
        pid=`cat $PID_FILE`
        kill $pid
        rm $PID_FILE
        ;;
esac
exit 0

