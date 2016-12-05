#!/bin/bash

INPUT="R2, L3" # 5
INPUT="R2, R2, R2" # 2
INPUT="R5, L5, R5, R3" # 12

INPUT="L3, R2, L5, R1, L1, L2, L2, R1, R5, R1, L1, L2, R2, R4, L4, L3, L3, R5, L1, R3, L5, L2, R4, L5, R4, R2, L2, L1, R1, L3, L3, R2, R1, L4, L1, L1, R4, R5, R1, L2, L1, R188, R4, L3, R54, L4, R4, R74, R2, L4, R185, R1, R3, R5, L2, L3, R1, L1, L3, R3, R2, L3, L4, R1, L3, L5, L2, R2, L1, R2, R1, L4, R5, R4, L5, L5, L4, R5, R4, L5, L3, R4, R1, L5, L4, L3, R5, L5, L2, L4, R4, R4, R2, L1, L3, L2, R5, R4, L5, R1, R2, R5, L2, R4, R5, L2, L3, R3, L4, R3, L2, R1, R4, L5, R1, L5, L3, R4, L2, L2, L5, L5, R5, R2, L5, R1, L3, L2, L2, R3, L3, L4, R2, R3, L1, R2, L5, L3, R4, L4, R4, R3, L3, R1, L3, R5, L5, R1, R5, R3, L1"

CURRENTLY_FACING=0
POSX=0
POSY=0

IFS=', ' read -ra ADDR <<< "$INPUT"
for i in "${ADDR[@]}"; do
    LOR="${i:0:1}"
    MOVES="${i:1:100}"

    # echo "$LOR - $MOVES"

    if [ $LOR == "R" ]
    then
        # echo "Turning right"
        CURRENTLY_FACING=$(($CURRENTLY_FACING+1))
    else
        # echo "Turning left"
        CURRENTLY_FACING=$(($CURRENTLY_FACING-1))
    fi

    # Underflow
    if [ $CURRENTLY_FACING -lt 0 ]
    then
        CURRENTLY_FACING=3
    fi

    # Overflow
    if [ $CURRENTLY_FACING == 4 ]
    then
        CURRENTLY_FACING=0
    fi

    if [ $CURRENTLY_FACING == 0 ]
    then
        POSY=$(($POSY+$MOVES)) 
    fi

    if [ $CURRENTLY_FACING == 1 ]
    then
        POSX=$(($POSX+$MOVES)) 
    fi

    if [ $CURRENTLY_FACING == 2 ]
    then
        POSY=$(($POSY-$MOVES)) 
    fi

    if [ $CURRENTLY_FACING == 3 ]
    then
        POSX=$(($POSX-$MOVES)) 
    fi
done

# Calculate absolute value
POSX=$(echo "$POSX" | tr -d -)
POSY=$(echo "$POSY" | tr -d -)

echo $(($POSX+$POSY))