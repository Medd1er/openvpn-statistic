#!/bin/bash
#
#   Variables
#
LOGPATH='/etc/openvpn/openvpn.log'
CONLOGPATH="/scripts/logs"
COUNT=1
#
#   Calculating all connections
#
NUMOFCON=$(cat $LOGPATH | grep -i -A 10000 'Common'| grep -v 'Common' | grep -i -B 10000 'Routing' | grep -v 'ROUTING' | wc -l)
if [ $NUMOFCON = 0 ]; then touch $CONLOGPATH/nconnections && echo $NUMOFCON > $CONLOGPATH/nconnections
fi
#
#   Checking if folder exist otherwise create it & write log. Else - clear directory and write log
#
if [ ! -d "$CONLOGPATH" ]; then
    mkdir "$CONLOGPATH"
else echo "" > $CONLOGPATH/nconnections && echo "" > $CONLOGPATH/openvpn-statistic.log
fi
    cat $LOGPATH | grep -i -A 10000 'Common'| grep -v 'Common' | grep -i -B 10000 'ROUTING' | grep -v 'ROUTING' | while read line
do
    echo $NUMOFCON > $CONLOGPATH/nconnections
    LOGIN=$(echo $line | cut -f1 -d',')
    REALIPADDR=$(echo $line | cut -f2 -d',')
    BYTESRECEIVED=$(echo $line | cut -f3 -d',')
    BYTESRECEIVED=$((BYTESRECEIVED/1024))
    BYTESSENT=$(echo $line | cut -f4 -d',')
    BYTESSENT=$((BYTESSENT/1024))
    CONNECTEDSINCE=$(echo $line | cut -f5 -d',' | tr '\ ' '-')
    VIRTUALIPADDR=$(cat $LOGPATH | grep -i -A 10000 'Virtual'| grep -v 'Virtual' | grep -i -B 10000 'GLOBAL' | grep -v 'GLOBAL' | cut -f1 -d',')
    VIRTUALIPADDR=$(echo $VIRTUALIPADDR | cut -f$COUNT -d ' ')
    LASTREF=$(cat $LOGPATH | grep -i -A 10000 'Virtual'| grep -v 'Virtual' | grep -i -B 10000 'GLOBAL' | grep -v 'GLOBAL' |  cut -f4 -d',' | tr '\ ' '-')
    LASTREF=$(echo $LASTREF | cut -f$COUNT -d ' ')
    echo "=== Connection <b>#"$COUNT"</b> statistic: ===<br>" >> $CONLOGPATH/openvpn-statistic.log
    echo "Login:      <b>"$LOGIN"</b><br>" >> $CONLOGPATH/openvpn-statistic.log
    echo "Real IP Address:   <b>"$REALIPADDR"</b><br>" >> $CONLOGPATH/openvpn-statistic.log
    echo "Virual IP Address: <b>"$VIRTUALIPADDR"</b><br>" >> $CONLOGPATH/openvpn-statistic.log
    echo "Bytes Rceived:     <b>"$BYTESRECEIVED" KB</b><br>" >> $CONLOGPATH/openvpn-statistic.log
    echo "Bytes Sent:        <b>"$BYTESSENT" KB</b><br>" >> $CONLOGPATH/openvpn-statistic.log
    echo "Connected since:   <b>"$CONNECTEDSINCE"</b><br>" >> $CONLOGPATH/openvpn-statistic.log
    echo "Last Ref:          <b>"$LASTREF"</b><br>" >> $CONLOGPATH/openvpn-statistic.log
    printf "\n<br>" >> $CONLOGPATH/openvpn-statistic.log
    COUNT=$((COUNT+1))
done
case $1 in
'numofcon') echo $NUMOFCON;;
'logs') cat $CONLOGPATH/openvpn-statistic.log;;
esac
    exit 1
