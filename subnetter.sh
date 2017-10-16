#!/bin/bash
s1=$1
s2=$2

#a.b.c.d/s
function log2 {
    local x=$1
    local i=0;
    while [ $x -gt 1 ]
    do
        x=`expr $x / 2`
        i=`expr $i + 1`
    done
    echo $i
}
#split variables
a=`echo $s1 | cut -d "." -f 1`
b=`echo $s1 | cut -d "." -f 2`
c=`echo $s1 | cut -d "." -f 3`
tem=`echo $s1 | cut -d "." -f 4`
d=`echo $tem | cut -d "/" -f 1`
s=`echo $tem | cut -d "/" -f 2`



sub=`expr 32 - $s`
num=`echo '2^'$sub | bc`
count=`expr $num - $d`

div=`expr $num / $s2`
realpow=$(log2 $div)
realbase=`echo '2^'$realpow | bc`
steps=`expr $count / $realbase`

maxsub=`expr $steps - $s2`
minsub=`expr $steps - $maxsub`
realmax=`expr 2 * $realbase`
hostmax=`expr $realmax - 3`
hostmin=`expr $realbase - 3`

while [ $s2 -ge 1 ]
    do
        if [ $maxsub -ge  1 ];
        then
            subdiff=`expr $(log2 $realmax)`
            submask=`expr 32 - $subdiff`
            echo "subnet=$a.$b.$c.$d/$submask network=$a.$b.$c.$d broadcast=$a.$b.$c.`expr $d + $realmax - 1` gateway=$a.$b.$c.1 hosts=$hostmax"
            d=`expr $d + $realmax`
            maxsub=`expr $maxsub - 1`
        else
            subdiff=`expr $(log2 $realbase)`
            submask=`expr 32 - $subdiff`
            echo "subnet=$a.$b.$c.$d/$submask network=$a.$b.$c.$d broadcast=$a.$b.$c.`expr $d + $realbase - 1` gateway=$a.$b.$c.`expr $d + 1` hosts=$hostmin"
            d=`expr $d + $realbase`
        fi
     s2=`expr $s2 - 1`
done