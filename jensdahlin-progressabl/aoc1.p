/*
Advent of code day 1 2016
*/

/* Instructionset downloaded from aoc... */
DEFINE VARIABLE cInstructions AS LONGCHAR NO-UNDO.

/* Coordinates */
DEFINE VARIABLE giY AS INTEGER     NO-UNDO.
DEFINE VARIABLE giX AS INTEGER     NO-UNDO.

/* Directions */
/*
/*This isn't really used - only for clarifying the idea */
DEFINE VARIABLE cDirection AS CHARACTER   NO-UNDO EXTENT 4 INITIAL ["N","E","S","W"].
    N + 1 = E
    E - 1 = N etc
*/

/* Index in array for direction - start out with north */
DEFINE VARIABLE iDirection AS INTEGER     NO-UNDO INITIAL 1.

/* Stepcounter */
DEFINE VARIABLE iStepCount AS INTEGER     NO-UNDO.

/* Steps to take */
DEFINE VARIABLE iStepsToTake AS INTEGER     NO-UNDO.

/* Read the input file */
COPY-LOB FROM FILE "input1.txt" TO cInstructions.

/* Remove idiotic spaces... */
cInstructions = REPLACE(cInstructions, " ", "").

/* Forward declare */
FUNCTION newDirection RETURNS INTEGER (INPUT iDir AS INTEGER, INPUT iChange AS INTEGER) FORWARD.

/* Go through the list of instructions */
DO iStepCount = 1 TO NUM-ENTRIES(cInstructions, ","):
    
    /* Turn */
    IF ENTRY(iStepCount, cInstructions, ",") BEGINS "L" THEN DO:
        iDirection = newDirection(iDirection, - 1).
    END.
    ELSE DO:
        iDirection = newDirection(iDirection, + 1).
    END.
    /* How many steps? */
    iStepsToTake = INTEGER(SUBSTRING(ENTRY(iStepCount, cInstructions, ","), 2)).
    
    /* Walk */
    CASE iDirection:
        WHEN 1 THEN giY = giY + iStepsToTake.
        WHEN 3 THEN giY = giY - iStepsToTake.
        WHEN 2 THEN giX = giX + iStepsToTake.
        WHEN 4 THEN giX = giX - iStepsToTake.
    END CASE.
END.

/* Display the resulting distance */
DISPLAY ABS(giY) + ABS(giX) LABEL "Distance" WITH FRAME x1 SIDE-LABELS 1 COLUMNS.

/***** Function for getting a new direction *******/
FUNCTION newDirection RETURNS INTEGER (INPUT iDir AS INTEGER, INPUT iChange AS INTEGER):

    iDir = iDir + iChange.

    IF iDir = 0 THEN
        iDir = 4.

    IF iDir = 5 THEN
        iDir = 1.

    RETURN iDir.

END FUNCTION.

