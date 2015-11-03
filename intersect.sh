# This script compares two lists
# $bash intersect.sh [-1=<colnum>]
#   [-2=<colnum>] [-v] list1 list2
# if you want to compare only one
# column from a file, use the
# -1/-file1col and/or the
# -2/-file2col arguments

VERBOSE="NO"
t="wc -l"

for i in "$@"
do
	case $i in
		-1=*|--file1col=*)
			FILE1COL="${i#*=}"
			shift 
			;;
		-2=*|--file2col=*)
			FILE2COL="${i#*=}"
			shift 
			;;
		-v|--verbose)
			VERBOSE=YES
			shift 
			;;
		*)
			;;
	esac
done


if [ ${VERBOSE} == "YES" ]; then
	echo "Comparing $1 to $2"
	echo "FILE 1 COL = ${FILE1COL}"
	echo "FILE 2 COL = ${FILE2COL}"
	echo "VERBOSE = ${VERBOSE}"
	t="tee >(wc -l)"
fi



if [ $FILE2COL > 0 ] || [ $FILE1COL > 0 ]; then

	if [ $FILE2COL > 0 ] && [ $FILE1COL > 0 ]; then
		comm -12 <(cut -f $FILE1COL $1|sort) <(cut -f $FILE2COL $2|sort) |$t

	else
		if [ $FILE1COL > 0 ]; then
			comm -12 <(cut -f $FILE1COL $1|sort) <(sort $2) |$t
		fi

		if [ $FILE2COL > 0 ]; then
			comm -12 <(sort $1) <(cut -f $FILE2COL $2| sort) |$t
		fi

	fi
else
	comm -12 <(sort $1) <(sort $2) |$t
fi
