/* AOC 2016 - day 3 - problem 2 */
/* The pain of trying to get the currect answer with only a part of the input file... */

DEFINE VARIABLE iSides AS INTEGER     NO-UNDO EXTENT 3.

DEFINE VARIABLE iOK    AS INTEGER     NO-UNDO.

/* Read the input from the file to a temporary table */
INPUT FROM VALUE("C:\temp\aoc2016\advent_of_code_2016\jensdahlin-progressabl\input3.txt").
REPEAT :
    IMPORT iSides.

    IF  iSides[1] + iSides[2] > iSides[3] 
    AND iSides[2] + iSides[3] > iSides[1]
    AND iSides[1] + iSides[3] > iSides[2] THEN
        iOK = iOK + 1.

END.
INPUT CLOSE.

MESSAGE "Correct triangles:" iOK VIEW-AS ALERT-BOX.
