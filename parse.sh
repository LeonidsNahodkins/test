service=$1
logname=$2

# Two possible date formats: "DD/MMM/YYYY:HH:mm:ss" OR "YYYY-MM-DDTHH:mm:ss"

# Get one day before last, in order to get the full day stats
date_pattern1="[0-9]{1,2}/[A-Za-z]{3}+/[0-9]{4}"
date_pattern2="[0-9]{4}+-[0-9]{2}-[0-9]{2}"
hour_pattern1="DAY:HOUR:[0-9]+:[0-9]+"
hour_pattern2="DAYTHOUR:[0-9]+:[0-9]+"

count1=$(cat ${logname} | grep -Eo "${date_pattern1}" | wc -l)
count2=$(cat ${logname} | grep -Eo "${date_pattern2}" | wc -l)

if [[ $count1 -gt $count2 ]]
then
echo "Format1 DD/MMM/YYYY:HH:mm:ss"
date_pattern=$date_pattern1
hour_pattern=$hour_pattern1
else
echo "Format2 YYYY-MM-DDTHH:mm:ss"
date_pattern=$date_pattern2
hour_pattern=$hour_pattern2
fi

days=$(cat ${logname} | grep -Eo "${date_pattern}" | sort | uniq)
echo "$days"
day=$(echo "${days}" | tail -n 2 | head -n 1 | grep -Eo $date_pattern)

echo "Counting stats hourly for this day $day"
echo "date_pattern = ${date_pattern}"
echo "hour_pattern = ${hour_pattern}"

for i in {1..24} 
do
hour=$(printf "%02d" $i)
thetime=$(echo ${hour_pattern} | sed "s~DAY~${day}~g" | sed "s~HOUR~${hour}~g")

count=$(cat  ${logname} | grep -E "${thetime}" | wc -l)
if [ $count -gt 0 ]
then
cat  ${logname} | grep -E "${thetime}" |  grep -Eo "(GET|POST|PUT|DELETE).* HTTP" | cut -d " " -f1,2 > ${service}_${hour}.dat
count=$(cat ${service}_${hour}.dat | wc -l)
fi
echo "$thetime count=$count"
done
