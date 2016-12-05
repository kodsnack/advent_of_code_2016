#!/bin/bash

INPUT="ULL
RRDDD
LURDL
UUUUD";

KEY="5"

while read line
do

    for (( i=0; i<${#line}; i++ )); do
        ACTION="${line:$i:1}";

        if [ $ACTION == "U" ]
        then
            if [ $KEY -gt 3 ]
            then
                KEY=$(($KEY-3));
            fi
        fi

        if [ $ACTION == "D" ]
        then
            if [ $KEY -lt 7 ]
            then
                KEY=$(($KEY+3));
            fi
        fi

        if [ $ACTION == "L" ]
        then
            if [ $KEY != "1" ] && [ $KEY != "4" ] && [ $KEY != "7" ]
            then
                KEY=$(($KEY-1));
            fi
        fi

        if [ $ACTION == "R" ]
        then
            if [ $KEY != "3" ] && [ $KEY != "6" ] && [ $KEY != "9" ]
            then
                KEY=$(($KEY+1));
            fi
        fi
    done

    echo "KEY: $KEY";
done < <(echo "$INPUT")