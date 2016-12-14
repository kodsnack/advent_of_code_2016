
&SCOPED-DEFINE startX 1
&SCOPED-DEFINE startY 1
&SCOPED-DEFINE goalX  31
&SCOPED-DEFINE goalY  39
&SCOPED-DEFINE maxX   50
&SCOPED-DEFINE maxY   50
&SCOPED-DEFINE fav    1358

/*
/* Testing values */
&SCOPED-DEFINE startX 1
&SCOPED-DEFINE startY 1
&SCOPED-DEFINE goalX  7
&SCOPED-DEFINE goalY  4
&SCOPED-DEFINE maxX   9
&SCOPED-DEFINE maxY   9
&SCOPED-DEFINE fav    10  
*/

DEFINE VARIABLE iSolution AS INTEGER     NO-UNDO.
DEFINE VARIABLE iX        AS INTEGER     NO-UNDO.
DEFINE VARIABLE iY        AS INTEGER     NO-UNDO.


DEFINE TEMP-TABLE ttSpace NO-UNDO
    FIELD sX     AS INTEGER
    FIELD sY     AS INTEGER
    FIELD isOpen AS LOGICAL
    INDEX id1 sX sY isOpen.

DEFINE TEMP-TABLE ttPath NO-UNDO
    FIELD pX   AS INTEGER
    FIELD pY   AS INTEGER
    FIELD step AS INTEGER
    INDEX id1 pX pY step.

/* Calculation */
FUNCTION calc RETURNS INTEGER (INPUT piX AS INTEGER, INPUT piY AS INTEGER, INPUT piFav AS INTEGER):
    RETURN piX * piX + 3 * piX  + 2 * piX * piY + piY + piY * piY + piFav.
END.

/* Create a binary string representation of an integer */
FUNCTION bBinary RETURNS CHARACTER (INPUT piValue AS INTEGER):
 
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.
 
    DO WHILE piValue > 0:
      ASSIGN 
         cReturn = STRING( piValue MOD 2 ) + cReturn
         piValue = TRUNCATE( piValue / 2, 0 ).
    END.
    
    IF cReturn = "" THEN cReturn = "0".

    IF LENGTH(cReturn) < 16 THEN 
        cReturn = FILL("0", 16 - LENGTH(cReturn)) + cReturn.
    
    RETURN cReturn.
 
END FUNCTION.

FUNCTION isOpen RETURNS LOGICAL( INPUT pcChar AS CHARACTER):

    DEFINE VARIABLE iCount AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iOnes   AS INTEGER     NO-UNDO.

    DO iCount = 1 TO LENGTH(pcChar):
        IF SUBSTRING(pcChar, iCount, 1) = "1" THEN
            iOnes = iOnes + 1.
    END.

    IF iOnes MOD 2 = 0 THEN
        RETURN TRUE.
    ELSE 
        RETURN FALSE.
END.

/* Create coords */
PROCEDURE createCoord:
    DEFINE INPUT  PARAMETER piX    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piY    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piStep AS INTEGER     NO-UNDO.
    
    /* Check if better path is already present */
    FIND FIRST ttPath WHERE ttPath.pX = piX 
                        AND ttPath.pY = piY NO-ERROR.
    IF AVAILABLE ttPath AND ttPath.step <= piStep THEN
        RETURN.
    
    /* Check if not out of bounds (and not a wall) */
    FIND FIRST ttSpace WHERE ttSpace.sX = piX 
                         AND ttSpace.sY = piY NO-ERROR.
    IF AVAILABLE ttSpace AND ttSpace.isOpen THEN DO:
        CREATE ttPath.
        ASSIGN 
            ttPath.step = piStep
            ttPath.pX   = piX
            ttPath.pY   = piY.
    END.
END.

/* Finding path = trying each direction from "this" position */
PROCEDURE findPath:
    DEFINE INPUT  PARAMETER piX      AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piY      AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piStep    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iX AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iY AS INTEGER     NO-UNDO.

    RUN createCoord(piX    , piY - 1, piStep + 1).
    RUN createCoord(piX    , piY + 1, piStep + 1).
    RUN createCoord(piX - 1, piY    , piStep + 1).
    RUN createCoord(piX + 1, piY    , piStep + 1).

END PROCEDURE.

/* Generate maze */
DO iY = 0 TO {&maxY}:
    DO iX = 0 TO {&maxX}:
        CREATE ttSpace.
        ASSIGN 
            ttSpace.sX = iX
            ttSpace.sY = iY.
            ttSpace.isOpen = isOpen(bBinary(calc(ix, iy, {&fav}))).
    END.
END.

/* Find the path */
/* Starting position */
RUN createCoord({&startX}, {&startY}, 0).

/* Classic but perhaps suboptimal pathfinding algorithm ... */
pathfinding:
REPEAT:
    FOR EACH ttPath :
        RUN findPath(ttPath.pX, ttPath.pY, ttpath.step).    
    END.
    
    FIND FIRST ttPath WHERE ttPath.Px = {&goalX}
                        AND ttPath.pY = {&goalY} NO-ERROR.
    IF AVAILABLE ttPath THEN DO:
        ASSIGN 
            iSolution =  ttPath.step.
        LEAVE pathfinding.
    END.
END.

MESSAGE "Steps: " iSolution VIEW-AS ALERT-BOX.

/* Output the maze with tested path */
OUTPUT TO "maze.txt".
DO iY = 0 TO {&maxY}:
    DO iX = 0 TO {&maxX}:
        FIND FIRST ttPath WHERE ttPath.pY = iY 
                            AND ttPath.pX = iX NO-ERROR.
        IF AVAILABLE ttpath THEN DO:
            
            PUT UNFORMATTED "P".
        END.
        ELSE DO:
            
            FIND FIRST ttSpace WHERE ttSpace.sY = iY 
                                 AND ttSpace.sX = iX NO-ERROR.
            IF AVAILABLE ttSpace THEN DO:
                IF ttSpace.isOpen THEN 
                    PUT UNFORMATTED  " ".
                ELSE 
                    PUT UNFORMATTED  "#".
            END.
        END.
    END.
    PUT SKIP.
END.
OUTPUT CLOSE.
