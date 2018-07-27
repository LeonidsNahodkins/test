urlsfile=$1
logfiles=`ls *.dat`

for logfile in $logfiles
do

total=`cat $logfile | wc -l`
echo
echo "====================="
echo "$logfile"
echo "====================="
printf "%10s %10s %s\n" "count" "percents" "endpont" 
printf "%10s %10s %s\n" "$total" "100%" "ALL" 

OLDIFS=$IFS
IFS=$'\n'
for i in $(cat ${urlsfile})
do
i=$(echo $i | tr -d '\n' | tr -d '\r')
count=$(cat $logfile | grep -E "$i" | wc -l)
count=$(grep -E "$i"  $logfile | wc -l)
percents=$((100*$count/$total))"%"
printf "%10s %10s %s\n" "$count" "$percents" "$i"
done
IFS=$OLDIFS

echo "====================="
done
