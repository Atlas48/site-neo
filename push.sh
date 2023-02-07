declare -a excl
#while read i; do
#  excl+=($i)
#done < tapeignore.txt
#unset i
cd ../..
rclone sync neo:/ ./
