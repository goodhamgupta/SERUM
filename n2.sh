#!/bin/bash
                                                    #Writing the 'OUT'records onto a new file
if [ -f final.txt ]
then
	rm final.txt
fi
if [ -f f1.txt ]
then
	rm f1.txt
fi

awk 'BEGIN {
            FS= " "
    }   {
    if ($3 ~ /OUT/)
            { FS = "@";
            print $0 }
    FS = " ";
    RS = "\n";
          }' info.txt > out.txt
     
                                                    #Writing the 'IN' records onto a new file
    awk 'BEGIN {
            FS= " "
    }   {
    if ($3 ~ /IN/)
            { 
            print $0 }
    FS = " ";
    RS = "\n";
          }' info.txt > inr.txt
     
j="0"
num="60"
echo "%" >> out.txt
echo "%" >> inr.txt
line=""
eof="%"
while [ "$line" != "$eof" ]
	read line
   	do
        	j=$((j+1))
		i="0"
	        var="$(echo $line | cut -d "@" -f2)"
		soft1="$(echo $line |cut -d "\"" -f2|cut -d " " -f2)"
		user="$(echo $line | cut -d  "@" -f1 | cut -d "/" -f2)"
		line2=""
        	while [ "$line2" != "$eof" ] 
        	do
		    read line2
        	    i=$((i+1))
        	    var1="$(echo $line2 | cut -d "@" -f2)"
		    soft2="$(echo $line2 |cut -d "\"" -f2)"
	            user2="$(echo $line2 | cut -d  "@" -f1 | cut -d "/" -f2)"
        	    if [ "$var" == "$var1" ] && [ "$soft1"  == "$soft2" ] && [ "$user" == "$user2" ]
        	    then
        	    {
			if [ -s inr.txt ]  && [ -s out.txt ]
			then
			{
				d1=$(echo ${line:0:8})
        	          	d2=$(echo ${line2:0:8})
				t1=$(echo ${line:0:2})
				u1=$(echo ${line2:0:2})
				t2=$(echo ${line:3:2})
				u2=$(echo ${line2:3:2})
				t3=$(echo ${line:6:2})
				u3=$(echo ${line2:6:2})
				#t1= $((t1-u1))
				t1=`echo "$t1 - $u1" | bc`
				t2=`echo "$t2 - $u2" | bc`
				t3=`echo "$t3 - $u3" | bc`
				t1=${t1#-}
				t2=${t2#-}
				t3=${t3#-}		
				t1=`echo "$t1 * 60 * 60" | bc`
				t2=`echo "$t2 * 60" | bc`
				t1=`echo "$t1 + $t2 + $t3" | bc`
				echo "$d1" >> final.txt
				echo "$d2" >> final.txt
				echo "$t1" >> final.txt
        	          	sed -i "$i"'d' inr.txt          #To delete the line from the 'IN' file
				echo "$user" >> final.txt
        			echo " $var" >> final.txt
				echo -e "$soft1" >> final.txt
        			sed -i "$j"'d' out.txt                          #To delete the line from the 'OUT' file
				break
			}
			fi
        	    }
		    else
		    {
			continue
		    }
        	    fi
        	done < inr.txt
	done < out.txt
echo -e "-----------------------------------------------------------------------------------------"
echo -e "Time OUT \t Time in \t Dur(s) \t User \t Machine \t Software"
echo -e "-----------------------------------------------------------------------------------------"
k="0"
l="6"
m="4"
while read l3
do
	k=$((k+1))
	if [ $k -eq $l ]
	then
	{
		echo -ne "$l3\t"
		echo -e "\n"
		k="0"
	}
	else
	{
		echo -ne "$l3 \t   "
	}
	fi
done < final.txt
#echo "%" >> final.txt
#-----------------------------------------GROUP WISE RECORDS -----------------------------------------------------------

x=""
c="0"
while read l4
do
	c=$((c+1))
	if [ $c -eq 6 ]
	then
	{
		x="$x$l4	"
		echo -e "$x\n" >> f1.txt
		c="0"
		x=""
	}
	else
		x="$x$l4	"
	fi
done < final.txt

echo -e "\n---------------------------GROUP 1-------------------------------\n"
echo -e "-----------------------------------------------------------------------------------------"
echo -e "Time OUT \t Time in \t Dur(s) \t User \t Machine \t Software"
echo -e "-----------------------------------------------------------------------------------------"

awk 'BEGIN {
            FS= " "
    }   {
    if ($4 ~ /user1/ || $4 == "user2" || $4 == "user3" || $4 ~ /user4/ )
            print $0,"\011" 
          }' f1.txt

echo -e "\n---------------------------GROUP 2-------------------------------\n"
echo -e "-----------------------------------------------------------------------------------------"
echo -e "Time OUT \t Time in \t Dur(s) \t User \t Machine \t Software"
echo -e "-----------------------------------------------------------------------------------------"

awk 'BEGIN {
            FS= " "
    }   {
    if ($4 ~ /user21/ || $4 ~ /user22/ || $4 ~ /user23/ || $4 ~ /user24/ )
            print $0 
          }' f1.txt
sed -i '$d' f1.txt
sed -i '$d' f1.txt


