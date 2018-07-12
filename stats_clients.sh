logname=$1
echo
echo "====================="
echo "stats for clients"
echo "====================="
total=`grep client= $logname | wc -l`
clients=`cat $logname | grep -oE "client=[a-z0-9-]+" | sort | uniq | cut -d "=" -f2 | grep -oE "[a-z0-9-]+" `
printf "%20s %10s %10s\n" "client" "count" "percents"
printf "%20s %10s %10s\n" "ALL" "$total" "100"
for i in $clients
do
count=`grep client=$i $logname | wc -l`
percents=$((100*$count/$total))"%"
printf "%20s %10s %10s\n" "$i"	"$count"	"$percents"
done
