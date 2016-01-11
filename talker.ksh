#!/bin/ksh
#talker 0.3

if [ $# -eq 0 ]
then
    set `date +%d%m%y`
else
    if [ `expr $1 : '.*'` -ne 6 ]
    then
    echo "talker: wrong date length... Usage: talker [ddmmyy]"; exit 1
    fi
    if echo $1|grep -q '[^0-9]'
    then
    echo "talker: wrong date format... Usage: talker [ddmmyy]"; exit 2
    fi
fi
dd=`expr $1 : '\(..\)'`
mm=`expr $1 : '..\(..\)'`
yy=`expr $1 : '....\(..\)'`

WDIR=`dirname $0`
DIR=${WDIR}/errpt_all
delimiter=#######################################

#echo $delimiter$delimiter
#echo "#   REPORT on $DIR   STARTED: `date`"
#echo $delimiter$delimiter
#echo
for file in $DIR/*
do
  nstr=`awk '{if (d==substr($2,1,4) substr($2,9,2)) n++}; END {print n}' d=$mm$dd$yy $file`
  if [ -n "$nstr" ]
  then
    echo $delimiter$delimiter
    echo "#  `basename $file`  REPORT on ${dd}.${mm}.${yy}"
    echo $delimiter$delimiter
    awk '{if (d==substr($2,1,4) substr($2,9,2)) print}' d=$mm$dd$yy $file
    echo
  fi
done
#echo $delimiter$delimiter
#echo "#   REPORT on $DIR   FINISHED: `date`"
#echo $delimiter$delimiter




# #!/bin/ksh
# #talker 0.2

# WDIR=`dirname $0`
# DIR=${WDIR}/errpt_all

# delimiter=########################################
# cur_date=`date +%m%d%y`
# for file in $DIR/*
# do
#   nstr=`awk '{if (d==substr($2,1,4) substr($2,9,2)) n++}; END {print n}' d=$cur_date $file`
#   if [ -n "$nstr" ]
#   then
#     echo $delimiter$delimiter
#     echo "#     `basename $file`       `date`"
#     echo $delimiter$delimiter
#     awk '{if (d==substr($2,1,4) substr($2,9,2)) print}' d=$cur_date $file
#     echo
#   fi
# done

# i=100 n_hosts=600 for_string=
# while [ "$i" -le "$n_hosts" ]
# do
# for_string="$for_string HOST$i->xxx.yyy.zzz.000"
# i=`expr $i + 1`
# done
# for i in $for_string
# do echo $i
# done