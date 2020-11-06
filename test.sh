	NONE_PENDING=$(git st | grep 'nothing to commit' | wc -l) 
	echo $NONE_PENDING 
	if [ "x$NONE_PENDING" = "x0" ]; then 
		echo "Can't push; Pending code changes" 
		exit 
	fi	