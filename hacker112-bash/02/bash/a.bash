#!/bin/bash

cd $(dirname $0)

getKeypadValue () {
    ROW=$1
    COL=$2
    VALUE=$((COL + 1 + ROW*3))
    echo -n $VALUE
}

## For printing keypad
# for (( i = 0; i < 3; i++ )); do
#     for (( j = 0; j < 3; j++ )); do
#         KEY=$(getKeypadValue $i $j)
#         echo -n "$KEY "
#     done
#     echo ""
# done

followCommands () {
    while [ $# -gt 0 ]; do
        case "$1" in
            U)
                if (( ROW > 0 )); then
                    ROW=$((ROW-1))
                fi
                ;;
            D)
                if (( ROW < 2 )); then
                    ROW=$((ROW+1))
                fi
                ;;
            L)
                if (( COL > 0 )); then
                    COL=$((COL-1))
                fi
                ;;
            R)
                if (( COL < 2 )); then
                    COL=$((COL+1))
                fi
                ;;
            *) echo "argument $1"
                ;;
        esac
#        echo "($ROW,$COL)"
        shift
    done
}

ROW=1
COL=1
while read LINE || [[ -n "$LINE" ]]
do
    # echo "LINE $LINE"
    COMMANDS=$(echo $LINE | sed -e 's/\(.\)/\1 /g')
    followCommands $COMMANDS
    getKeypadValue $ROW $COL
done < ../input.txt
echo ""