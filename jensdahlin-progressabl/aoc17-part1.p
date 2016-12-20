
&SCOPED-DEFINE startX 1
&SCOPED-DEFINE startY 1
&SCOPED-DEFINE goalX  4
&SCOPED-DEFINE goalY  4
&SCOPED-DEFINE maxX   4
&SCOPED-DEFINE maxY   4
&SCOPED-DEFINE passcode "veumntbg"

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

DEFINE VARIABLE cPath     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iX        AS INTEGER     NO-UNDO.
DEFINE VARIABLE iY        AS INTEGER     NO-UNDO.

PROCEDURE getOpenDoors:
    DEFINE INPUT  PARAMETER pcString    AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER plOpen AS LOGICAL     NO-UNDO EXTENT 4.
    
    DEFINE VARIABLE iNum  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE rVar  AS RAW       NO-UNDO.
    DEFINE VARIABLE cChar AS CHARACTER   NO-UNDO.
    
    rVar = MD5-DIGEST(pcString).
    
    DO iNum = 1 TO 4 :
        cChar = SUBSTRING(STRING(HEX-ENCODE(rVar)), iNum, 1).
        
        IF INDEX("bcdef", cChar) > 0 THEN
            plOpen[iNum] = TRUE.

    END.

END.


DEFINE TEMP-TABLE ttPath NO-UNDO
    FIELD pX   AS INTEGER
    FIELD pY   AS INTEGER
    FIELD step AS INTEGER
    FIELD path AS CHARACTER
    INDEX id1 pX pY step.

/* Create coords */
PROCEDURE createCoord:
    DEFINE INPUT  PARAMETER piX    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piY    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piStep AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pcPath AS CHARACTER   NO-UNDO.
    
    /* Check if better path is already present */
    
    FIND FIRST ttPath WHERE ttPath.pX = piX 
                        AND ttPath.pY = piY NO-ERROR.
    IF AVAILABLE ttPath AND ttPath.path = pcPath THEN
        RETURN.
    
    CREATE ttPath.
    ASSIGN 
        ttPath.step = piStep
        ttPath.pX   = piX
        ttPath.pY   = piY
        ttPath.path = pcPath.

END.

/* Finding path = trying each direction from "this" position */
PROCEDURE findPath:
    DEFINE INPUT  PARAMETER piX      AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piY      AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piStep    AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER pcPAth    AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iX AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iY AS INTEGER     NO-UNDO.

    DEFINE VARIABLE lDoors AS LOGICAL     NO-UNDO EXTENT 4.
    
    RUN getOpenDoors(INPUT {&passcode} + pcPath, OUTPUT lDoors).

    IF piY > {&startY} AND lDoors[1] THEN
        RUN createCoord(piX    , piY - 1, piStep + 1, pcPath + "U").
    IF piY < {&goalY} AND lDoors[2] THEN
        RUN createCoord(piX    , piY + 1, piStep + 1, pcPath + "D").
    IF piX > {&startX} AND lDoors[3] THEN
        RUN createCoord(piX - 1, piY    , piStep + 1, pcPath + "L").
    IF piX < {&goalX} AND lDoors[4] THEN
        RUN createCoord(piX + 1, piY    , piStep + 1, pcPath + "R").

END PROCEDURE.

/* Find the path */
/* Starting position */
RUN createCoord({&startX}, {&startY}, 0, "").

/* Classic but perhaps suboptimal pathfinding algorithm ... */
pathfinding:
REPEAT:
    FOR EACH ttPath :
        RUN findPath(ttPath.pX, ttPath.pY, ttpath.step, ttPath.path).    
    END.

    FIND FIRST ttPath WHERE ttPath.Px = {&goalX}
                        AND ttPath.pY = {&goalY} NO-ERROR.
    IF AVAILABLE ttPath THEN DO:
        ASSIGN 
            cPath     = ttPath.path.
        LEAVE pathfinding.
    END.
END.

MESSAGE "Path: " cPath "/" LENGTH(cPath) VIEW-AS ALERT-BOX.
