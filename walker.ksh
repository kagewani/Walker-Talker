#!/bin/ksh -x
#walker 0.36
# Global Environment
WDIR=`dirname $0`
TMP="tmpfile"
OUTPUT="output"
###############################################################################
#
#  Name: walker
#
#  Walks around and pulls something by ssh
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
            if [ -s $WDIR/$DIR/$TMP ]
                then
                    mv $WDIR/$DIR/$TMP $WDIR/$DIR/$FILENAME
                    rm $WDIR/$DIR/$OUTPUT
                    rm $WDIR/$DIR/$FILENAME.new
                else
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

# #!/bin/ksh -x
# #walker 0.36
# ###
# WDIR=`dirname $0`
# TMP="tmpfile"
# OUTPUT="output"
# ###
# HOSTS_FILE="aixlist"
# CMD="errpt"
# DIR="errpt_aix"
# USERNAME="root"
# ###

# HOSTS=`awk '{print $1}' $WDIR/$HOSTS_FILE`
# for HOST in $HOSTS
# do
#     NAME=`egrep $HOST[[:blank:]] $WDIR/$HOSTS_FILE| awk '{print $2}'`
#     FILENAME=$NAME\_$HOST 
#     # Check SSH options!!!???? "Permanently added" does no count as error and written to stdout
#     # >Warning: Permanently added '192.168.97.175' (RSA) to the list of known hosts.
#     ssh -oBatchMode=yes -o StrictHostKeyChecking=no -oConnectTimeout=3 $USERNAME@$HOST "$CMD" >$WDIR/$DIR/$OUTPUT 2>&1
#     exst=$?
#     cat $WDIR/$DIR/$OUTPUT | tr '\r' '\n'>$WDIR/$DIR/$FILENAME.new  
#     if [ $exst -ne 0 ]
#     then
#         echo "`date`    $NAME    $HOST    `head -1 $WDIR/$DIR/$OUTPUT`">>$WDIR/warnings
#         rm $WDIR/$DIR/$OUTPUT
#         rm $WDIR/$DIR/$FILENAME.new
#         continue
#     fi
#     if [ -f $WDIR/$DIR/$FILENAME ]
#     then
#         diff -D "" $WDIR/$DIR/$FILENAME.new $WDIR/$DIR/$FILENAME| sed -e '/^#/d; /^ *$/d'>$WDIR/$DIR/$TMP
#         if [ -s $WDIR/$DIR/$TMP ]
#             then
#                 mv $WDIR/$DIR/$TMP $WDIR/$DIR/$FILENAME
#                 rm $WDIR/$DIR/$OUTPUT
#                 rm $WDIR/$DIR/$FILENAME.new
#             else
#             rm $WDIR/$DIR/$OUTPUT
#             rm $WDIR/$DIR/$FILENAME.new
#         fi
#     else
#         sed '/^#/d; /^ *$/d' $WDIR/$DIR/$FILENAME.new>$WDIR/$DIR/$FILENAME
#         rm $WDIR/$DIR/$OUTPUT
#         rm $WDIR/$DIR/$FILENAME.new
#     fi
# done

# ###
# HOSTS_FILE="vioslist"
# CMD="ioscli errlog"
# DIR="errpt_vios"
# USERNAME="padmin"
# ###

# HOSTS=`awk '{print $1}' $WDIR/$HOSTS_FILE`
# for HOST in $HOSTS
# do
#     NAME=`egrep $HOST[[:blank:]] $WDIR/$HOSTS_FILE| awk '{print $2}'`
#     FILENAME=$NAME\_$HOST 
#     # Check SSH options!!!???? "Permanently added" does no count as error and written to stdout
#     # >Warning: Permanently added '192.168.97.175' (RSA) to the list of known hosts.
#     ssh -oBatchMode=yes -o StrictHostKeyChecking=no -oConnectTimeout=3 $USERNAME@$HOST "$CMD" >$WDIR/$DIR/$OUTPUT 2>&1
#     exst=$?
#     cat $WDIR/$DIR/$OUTPUT | tr '\r' '\n'>$WDIR/$DIR/$FILENAME.new  
#     if [ $exst -ne 0 ]
#     then
#         echo "`date`    $NAME    $HOST    `head -1 $WDIR/$DIR/$OUTPUT`">>$WDIR/warnings
#         rm $WDIR/$DIR/$OUTPUT
#         rm $WDIR/$DIR/$FILENAME.new
#         continue
#     fi
#     if [ -f $WDIR/$DIR/$FILENAME ]
#     then
#         diff -D "" $WDIR/$DIR/$FILENAME.new $WDIR/$DIR/$FILENAME| sed -e '/^#/d; /^ *$/d'>$WDIR/$DIR/$TMP
#         if [ -s $WDIR/$DIR/$TMP ]
#             then
#                 mv $WDIR/$DIR/$TMP $WDIR/$DIR/$FILENAME
#                 rm $WDIR/$DIR/$OUTPUT
#                 rm $WDIR/$DIR/$FILENAME.new
#             else
#             rm $WDIR/$DIR/$OUTPUT
#             rm $WDIR/$DIR/$FILENAME.new
#         fi
#     else
#         sed '/^#/d; /^ *$/d' $WDIR/$DIR/$FILENAME.new>$WDIR/$DIR/$FILENAME
#         rm $WDIR/$DIR/$OUTPUT
#         rm $WDIR/$DIR/$FILENAME.new
#     fi
# done

# #!/bin/ksh -x
# #walker 0.31

# WDIR=`dirname $0`
# HOSTS_FILE="aixlist"
# HOSTS=`awk '{print $1}' $WDIR/$HOSTS_FILE`
# CMD=errpt
# DIR=/errpt_all/
# TMP=tmpfile
# OUTPUT=output

# for HOST in $HOSTS
# do
#     NAME=`egrep $HOST[[:blank:]] $WDIR/$HOSTS_FILE| awk '{print $2}'`
#     FILENAME=$NAME\_$HOST 
# # Check SSH options!!!???? "Permanently added" does no count as error and written to stdout
# # Warning: Permanently added '192.168.97.175' (RSA) to the list of known hosts.
#     ssh -oBatchMode=yes -o StrictHostKeyChecking=no -oConnectTimeout=2 root@$HOST "$CMD" >$WDIR$DIR$OUTPUT 2>&1
#     exst=$?
#     cat $WDIR$DIR$OUTPUT | tr '\r' '\n'>$WDIR$DIR$FILENAME.new  
#     if [ $exst -ne 0 ]
#     then
#         echo "`date`    $NAME    $HOST    `head -1 $WDIR$DIR$OUTPUT`">>$WDIR/warnings
#         rm $WDIR$DIR$OUTPUT
#         rm $WDIR$DIR$FILENAME.new
#         continue
#     fi
#     if [ -f $WDIR$DIR$FILENAME ]
#     then

# #0 11 * * * /usr/bin/errclear -d S,O 30
# #0 12 * * * /usr/bin/errclear -d H 90

# #        DIFF=`diff -D "" $WDIR$DIR$FILENAME.new $WDIR$DIR$FILENAME`
#         diff -D "" $WDIR$DIR$FILENAME.new $WDIR$DIR$FILENAME| sed -e '/^#/d; /^ *$/d'>$WDIR$DIR$TMP
#         if [ -s $WDIR$DIR$TMP]
#             then
# #                diff -D "" $WDIR$DIR$FILENAME.new $WDIR$DIR$FILENAME| sed -e '/^#/d; /^ *$/d'>$WDIR$DIR$TMP
#                 mv $WDIR$DIR$TMP $WDIR$DIR$FILENAME
#                 rm $WDIR$DIR$OUTPUT
#                 rm $WDIR$DIR$FILENAME.new
#             else
#             rm $WDIR$DIR$OUTPUT
#             rm $WDIR$DIR$FILENAME.new
#         fi
#     else
#         sed '/^#/d; /^ *$/d' $WDIR$DIR$FILENAME.new>$WDIR$DIR$FILENAME
#         rm $WDIR$DIR$OUTPUT
#         rm $WDIR$DIR$FILENAME.new
#     fi
# done


# #!/bin/ksh
# #walker 0.28

# WDIR=`dirname $0`
# HOSTS=`awk '{print $1}' $WDIR/aixlist`
# #NAMES=`awk '{print $2}' $WDIR/aixlist`

# CMD=errpt
# DIR=/errpt_all/
# TMP=tmpfile

# for HOST in $HOSTS
# do
#     NAME=`fgrep "$HOST " $WDIR/aixlist | awk '{print $2}'`
# # {}
#     FILENAME=$NAME\_$HOST

# # Check SSH options!!!???? "Permanently added" does no count as error and written to stdout
# # Warning: Permanently added '192.168.97.175' (RSA) to the list of known hosts.
#     ssh -oBatchMode=yes -o StrictHostKeyChecking=no -oConnectTimeout=3 root@$HOST "$CMD" >$WDIR$DIR/exst 2>&1
#     exst=$?
#     cat $WDIR$DIR/exst | tr '\r' '\n'>$WDIR$DIR$FILENAME.new
#     if [ $exst -ne 0 ]
#     then
#         echo "`date`    $NAME    $HOST    `head -1 $WDIR$DIR/exst`">>$WDIR/warnings
#         rm $WDIR$DIR/exst
#         rm $WDIR$DIR$FILENAME.new
#         continue
#     fi
# if [ -f $WDIR$DIR$FILENAME ]
#     then

# # Due to default root Crontab
# #0 11 * * * /usr/bin/errclear -d S,O 30
# #0 12 * * * /usr/bin/errclear -d H 90

#         DIFF=`diff -D "" $WDIR$DIR$FILENAME.new $WDIR$DIR$FILENAME`
#         if [ "$DIFF" ]
#             then
#                 diff -D "" $WDIR$DIR$FILENAME.new $WDIR$DIR$FILENAME| sed -e '/^#/d; /^ *$/d'>$WDIR$DIR$TMP
#                 mv $WDIR$DIR$TMP $WDIR$DIR$FILENAME
#                 rm $WDIR$DIR$FILENAME.new
#                 rm $WDIR$DIR/exst
#             else
#             rm $WDIR$DIR/exst
#             rm $WDIR$DIR$FILENAME.new
#         fi
#     else
#         sed '/^#/d; /^ *$/d' $WDIR$DIR$FILENAME.new>$WDIR$DIR$FILENAME
#         rm $WDIR$DIR/exst
#         rm $WDIR$DIR$FILENAME.new
#     fi
# done

# #!/bin/ksh -x
# #walker 0.23

# WDIR=`dirname $0`
# HOSTS=`awk '{print $1}' $WDIR/aixlist`
# #NAMES=`awk '{print $2}' $WDIR/aixlist`

# CMD=errpt
# DIR=/errpt_all/
# TMP=tmpfile

# for HOST in $HOSTS
# do
#     NAME=`fgrep "$HOST" $WDIR/aixlist | awk '{print $2}'`
#     FILENAME=$NAME\_$HOST 
# # Check SSH options!!!????
#     ssh -oBatchMode=yes -o StrictHostKeyChecking=no -oConnectTimeout=1 root@$HOST "$CMD" >$WDIR$DIR/exst 2>&1
#     exst=$?
#     cat $WDIR$DIR/exst | tr '\r' '\n'>$WDIR$DIR$FILENAME.new  
#     if [ $exst -ne 0 ]
#     then
#         echo "`date`    $NAME    $HOST    `head -1 $WDIR$DIR/exst`">>$WDIR/warnings
#         rm $WDIR$DIR/exst
#         rm $WDIR$DIR$FILENAME.new
#         continue
#     fi
#     if [ -f $WDIR$DIR$FILENAME ]
#     then

# # Due to standart Crontab  
# #0 11 * * * /usr/bin/errclear -d S,O 30
# #0 12 * * * /usr/bin/errclear -d H 90

#         DIFF=`diff -D "" $WDIR$DIR$FILENAME.new $WDIR$DIR$FILENAME`
#         if [ "$DIFF" ]
#             then
#                 diff -D "" $WDIR$DIR$FILENAME.new $WDIR$DIR$FILENAME| sed -e 's/#.*$//' -e '/^$/d'>$WDIR$DIR$TMP
#                 mv $WDIR$DIR$TMP $WDIR$DIR$FILENAME
#                 #rm $WDIR$DIR$FILENAME.new
#             else
#             rm $WDIR$DIR$FILENAME.new
#         fi
#     else
#         sed -e 's/#.*$//' -e '/^$/d' $WDIR$DIR$FILENAME.new>$WDIR$DIR$FILENAME
#         rm $WDIR$DIR$FILENAME.new
#     fi
# done



# #!/bin/ksh -x
# #walker 0.19

# # Redo with $?
# SSH_error1="Permission denied (publickey,password,keyboard-interactive)."
# SSH_error2="Host key verification failed."
# SSH_error3="ssh: connect to host"

# WDIR=`dirname $0`
# HOSTS=`awk '{print $1}' $WDIR/aixlist`
# #NAMES=`awk '{print $2}' $WDIR/aixlist`

# CMD=errpt
# DIR=/errpt_all/
# TMP=tmpfile

# for HOST in $HOSTS
# do
#     NAME=`fgrep "$HOST" $WDIR/aixlist|awk '{print $2}'`
#     FILENAME=$NAME\_$HOST 
#     ssh -oBatchMode=yes -o StrictHostKeyChecking=no -oConnectTimeout=1 root@$HOST "$CMD" 2>&1|tr '\r' '\n'>$WDIR$DIR$FILENAME.new
#     SSH_error=`head -1 $WDIR$DIR$FILENAME.new`
#     if [[ "$SSH_error" = "$SSH_error1"||"$SSH_error" = "$SSH_error2"||"$SSH_error" = "$SSH_error3"* ]]
#     then
#         echo "`date`    $NAME    $HOST    $SSH_error">>$WDIR/warnings
#         rm $WDIR$DIR$FILENAME.new
#         continue
#     fi
#     if [ -f $WDIR$DIR$FILENAME ]
#     then
#         DIFF=`diff -D "" $WDIR$DIR$FILENAME.new $WDIR$DIR$FILENAME`
#         if [ "$DIFF" ]
#             then
#                 diff -D "" $WDIR$DIR$FILENAME.new $WDIR$DIR$FILENAME| sed -e 's/#.*$//' -e '/^$/d'>$WDIR$DIR$TMP
#                 mv $WDIR$DIR$TMP $WDIR$DIR$FILENAME
#                 rm $WDIR$DIR$FILENAME.new
#             else
#             rm $WDIR$DIR$FILENAME.new
#         fi
#     else
#         sed -e 's/#.*$//' -e '/^$/d' $WDIR$DIR$FILENAME.new>$WDIR$DIR$FILENAME
#         rm $WDIR$DIR$FILENAME.new
#     fi
# done