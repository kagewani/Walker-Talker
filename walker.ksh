#!/bin/ksh -x
#walker 0.37
# Global Environment
WDIR=`dirname $0`
TMP="tmpfile"
OUTPUT="output"
###############################################################################
#
#  Name: walker
#
#  Walks around and pulls errpt/errlog by ssh
#
#  Arguments:   none
#
#  Usage:        walker_routine
#
#  Returns:      0         Success
#                1         Failure
#
#  Environment: WDIR and temporary file names
#
###############################################################################
walker_routine()
{
    HOSTS=`awk '{print $1}' $WDIR/$HOSTS_FILE`
    for HOST in $HOSTS
    do
        NAME=`egrep $HOST[[:blank:]] $WDIR/$HOSTS_FILE| awk '{print $2}'`
        FILENAME=$NAME\_$HOST 
        # Check SSH options!!!???? "Permanently added" does no count as error and written to stdout
        # >Warning: Permanently added '192.168.97.175' (RSA) to the list of known hosts.
        ssh -oBatchMode=yes -o StrictHostKeyChecking=no -oConnectTimeout=3 $USERNAME@$HOST "$CMD" >$WDIR/$DIR/$OUTPUT 2>&1
        exst=$?
        cat $WDIR/$DIR/$OUTPUT | tr '\r' '\n'>$WDIR/$DIR/$FILENAME.new  
        if [ $exst -ne 0 ]
        then
            echo "`date`    $NAME    $HOST    `head -1 $WDIR/$DIR/$OUTPUT`">>$WDIR/warnings
            rm $WDIR/$DIR/$OUTPUT
            rm $WDIR/$DIR/$FILENAME.new
            continue
        fi
        if [ -f $WDIR/$DIR/$FILENAME ]
        then
            diff -D "" $WDIR/$DIR/$FILENAME.new $WDIR/$DIR/$FILENAME| sed -e '/^#/d; /^ *$/d'>$WDIR/$DIR/$TMP
            if [ -s $WDIR/$DIR/$TMP ] # and if empty?
                then
                    mv $WDIR/$DIR/$TMP $WDIR/$DIR/$FILENAME
                    rm $WDIR/$DIR/$OUTPUT
                    rm $WDIR/$DIR/$FILENAME.new
                else
                rm $WDIR/$DIR/$TMP
                rm $WDIR/$DIR/$OUTPUT
                rm $WDIR/$DIR/$FILENAME.new
            fi
        else
            sed '/^#/d; /^ *$/d' $WDIR/$DIR/$FILENAME.new>$WDIR/$DIR/$FILENAME
            rm $WDIR/$DIR/$OUTPUT
            rm $WDIR/$DIR/$FILENAME.new
        fi
    done
}

# Aix section
HOSTS_FILE="aixlist"
CMD="errpt"
DIR="errpt_aix"
USERNAME="root"

walker_routine

# VIOS section 
HOSTS_FILE="vioslist"
CMD="ioscli errlog"
DIR="errpt_vios"
USERNAME="padmin"

walker_routine