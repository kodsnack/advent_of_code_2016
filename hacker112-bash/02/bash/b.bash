#!/bin/bash

cd $(dirname $0)

printHex () {
    printf '%X' $1
}

getKeypadValue () {
    ROW=$1
    COL=$2
    VALUE=$((COL + 1 + ROW*3))
    if ((ROW == 0 && COL == 2)); then
        printHex 1
    elif ((ROW == 1 && COL >= 1 && COL <= 3)); then
        printHex $((1+COL))
    elif ((ROW == 2 && COL >= 0 && COL <= 4)); then
        printHex $((5+COL))
    elif ((ROW == 3 && COL >= 1 && COL <= 3)); then
        printHex $((9+COL))
    elif ((ROW == 4 && COL == 2)); then
        printHex 13
    else
        printf ' '
    fi
}



# For printing keypad
for (( i = 0; i < 5; i++ )); do
    for (( j = 0; j < 5; j++ )); do
        KEY=$(getKeypadValue $i $j)
        echo -n "$KEY "
    done
    echo ""
done
echo ""


followCommands () {
    while [ $# -gt 0 ]; do
        NEXT_ROW=$ROW
        NEXT_COL=$COL
        case "$1" in
            U)
                NEXT_ROW=$((ROW-1))
                if [[ $(getKeypadValue $NEXT_ROW $NEXT_COL) != " " ]]; then
                    ROW=$NEXT_ROW
                fi
                ;;
            D)
                NEXT_ROW=$((ROW+1))
                if [[ $(getKeypadValue $NEXT_ROW $NEXT_COL) != " " ]]; then
                    ROW=$NEXT_ROW
                fi
                ;;
            L)
                NEXT_COL=$((COL-1))
                if [[ $(getKeypadValue $NEXT_ROW $NEXT_COL) != " " ]]; then
                    COL=$NEXT_COL
                fi
                ;;
            R)
                NEXT_COL=$((COL+1))
                if [[ $(getKeypadValue $NEXT_ROW $NEXT_COL) != " " ]]; then
                    COL=$NEXT_COL
                fi
                ;;
            *) echo "argument $1"
                ;;
        esac
        shift
    done
}

ROW=2
COL=0
while read LINE || [[ -n "$LINE" ]]
do
    # echo "LINE $LINE"
    COMMANDS=$(echo $LINE | sed -e 's/\(.\)/\1 /g')
    followCommands $COMMANDS
    getKeypadValue $ROW $COL
done < ../input.txt
echo ""