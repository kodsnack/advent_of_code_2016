/*
Advent of code day 1 2016

Solving both problem 1 and problem 2
*/


/* Instructionset downloaded from aoc... */
DEFINE VARIABLE cInstructions AS LONGCHAR NO-UNDO.

/* Save the path as individual steps */
DEFINE TEMP-TABLE ttStep NO-UNDO
    FIELD nr AS INTEGER
    FIELD cY AS INTEGER
    FIELD cX AS INTEGER
    INDEX nr nr 
    INDEX coordinates cy cx.

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

/* The "small" steps */
DEFINE VARIABLE giStep AS INTEGER     NO-UNDO.
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
        WHEN 1 THEN DO:
            RUN walk(iStepCount, "y", iStepsToTake).
            giY = giY + iStepsToTake.
        END.
        WHEN 3 THEN DO:
            RUN walk(iStepCount, "y", - iStepsToTake).
            giY = giY - iStepsToTake.
        END.
        WHEN 2 THEN DO:
            RUN walk(iStepCount, "x", iStepsToTake).
            giX = giX + iStepsToTake.
        END.
        WHEN 4 THEN DO:
            RUN walk(iStepCount, "x", - iStepsToTake).
            giX = giX - iStepsToTake.
        END.
    END CASE.
END.

/* Display the resulting distance */
DISPLAY ABS(giY) + ABS(giX) LABEL "Distance" WITH FRAME x1 SIDE-LABELS 1 COLUMNS.

/*
FOR EACH ttSTep:
    DISP ttStep.
END.
*/

/* Find revisits... */
DEFINE BUFFER bStep FOR ttStep.

revisit:
FOR EACH ttStep:
    FOR EACH  bStep NO-LOCK WHERE bStep.cy = ttStep.cy 
                              AND bStep.cx = ttStep.cx
                              AND ROWID(bStep) <> ROWID(ttStep) 
                               BY bStep.nr:
        DISP "First revisit:" bStep.cy bStep.cx ABS(bSTep.cy) + ABS(bSTep.cX).
        LEAVE revisit.
    END.
END.

/* 
Procedure for walking... Not too satisfied with this one...
TODO: Think better
*/
PROCEDURE walk:
    DEFINE INPUT  PARAMETER piNr        AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pcDirection AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER piMoves     AS INTEGER     NO-UNDO.

    DEFINE VARIABLE iMoveCount AS INTEGER     NO-UNDO.
    
    DO iMoveCount = 1 TO ABS(piMoves):
        
        giStep = giStep + 1.

        CREATE ttStep.
        ASSIGN 
            ttStep.nr = giStep.
        
        
        IF pcDirection = "y" THEN
            ASSIGN 
                ttStep.cY = giY + iMoveCount * (IF piMoves < 0 THEN -1 ELSE 1)
                ttStep.cX = giX.
        ELSE
            ASSIGN 
                ttStep.cX = giX + iMoveCount * (IF piMoves < 0 THEN -1 ELSE 1)
                ttStep.cy = giY.
        
        //DISP ttStep.
        //PAUSE.
        
    END.
    
END PROCEDURE.

/***** Function for getting a new direction *******/
FUNCTION newDirection RETURNS INTEGER (INPUT iDir AS INTEGER, INPUT iChange AS INTEGER):

    iDir = iDir + iChange.

    IF iDir = 0 THEN
        iDir = 4.

    IF iDir = 5 THEN
        iDir = 1.

    RETURN iDir.

END FUNCTION.

