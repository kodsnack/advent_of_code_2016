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
            if [ $KEY == "3" ]; then
                KEY="1"
            elif [ $KEY == "6" ] || [ $KEY == "7" ] || [ $KEY == "8" ]; then
                KEY=$(($KEY-4))
            elif [ $KEY == "A" ]; then
                KEY="6"
            elif [ $KEY == "B" ]; then
                KEY="7"
            elif [ $KEY == "C" ]; then
                KEY="8"
            elif [ $KEY == "D" ]; then
                KEY="B"
            fi
        fi

        if [ $ACTION == "D" ]
        then
            if [ $KEY == "1" ]; then
                KEY="3"
            elif [ $KEY == "2" ] || [ $KEY == "3" ] || [ $KEY == "4" ]; then
                KEY=$(($KEY+4))
            elif [ $KEY == "6" ]; then
                KEY="A"
            elif [ $KEY == "7" ]; then
                KEY="B"
            elif [ $KEY == "8" ]; then
                KEY="C"
            elif [ $KEY == "B" ]; then
                KEY="D"
            fi
        fi

        if [ $ACTION == "L" ]
        then
            if [ $KEY == "3" ] || [ $KEY == "4" ] || [ $KEY == "6" ] || [ $KEY == "7" ] || [ $KEY == "8" ] || [ $KEY == "9" ]; then
                KEY=$(($KEY-1))
            elif [ $KEY == "B" ]; then
                KEY="A"
            elif [ $KEY == "C" ]; then
                KEY="B"
            fi
        fi

        if [ $ACTION == "R" ]
        then
            if [ $KEY == "2" ] || [ $KEY == "3" ] || [ $KEY == "5" ] || [ $KEY == "6" ] || [ $KEY == "7" ] || [ $KEY == "8" ]; then
                KEY=$(($KEY+1))
            elif [ $KEY == "A" ]; then
                KEY="B"
            elif [ $KEY == "B" ]; then
                KEY="C"
            fi
        fi
    done

    echo "KEY: $KEY";
done < <(echo "$INPUT")