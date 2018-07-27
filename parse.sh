service=$1
logname=$2

cat ${logname} | grep -Eo "(GET|POST|PUT|DELETE).* HTTP" | cut -d " " -f1,2 > ${service}.dat

#Get list of all days when Timestams like this [2018-07-11T06:53:55+00:00]
days=$(cat ${logname} | grep -Eo [0-9]+-[0-9]+-[0-9]+T | uniq)
#Get one day before last, in order to get the full day stats
day=$(echo "${days}" | tail -n 2 | head -n 1 | grep -Eo [0-9]+-[0-9]+-[0-9]+)
echo "Counting stats hourly for this day $day"

for i in {1..24} 
do
hour=$(printf "%02d" $i)
thetime=$(printf "%sT%s" ${day} ${hour})
count=$(cat  ${logname} | grep "${thetime}" | wc -l)
if [ $count -gt 0 ]
then
cat  ${logname} | grep "$thetime" |  grep -Eo "(GET|POST|PUT|DELETE).* HTTP" | cut -d " " -f1,2 > ${service}_${hour}.dat
count=$(cat  ${service}_${hour}.dat | wc -l)
fi
echo "$thetime count=$count"
done
