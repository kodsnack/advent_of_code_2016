&SCOPED-DEFINE maxY 5
&SCOPED-DEFINE maxX 49

DEFINE TEMP-TABLE ttDisplay NO-UNDO
    FIELD colX  AS INTEGER
    FIELD rowY  AS INTEGER
    FIELD isLit AS LOGICAL
    INDEX id1 colX rowY.

DEFINE VARIABLE iMaxX  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxY  AS INTEGER     NO-UNDO.

DEFINE VARIABLE iLit   AS INTEGER     NO-UNDO.
DEFINE VARIABLE cInput AS CHARACTER   NO-UNDO EXTENT 5.

DO iMaxX = 0 TO {&maxX}:
    DO iMaxY = 0 TO {&maxY}:
        RUN createRect(iMaxX, iMaxY, FALSE).
    END.
END.




INPUT FROM VALUE("input8.txt").
REPEAT:
    IMPORT cInput.

    IF cInput[1] = "rect" THEN
        RUN createRect(INTEGER(ENTRY(1, cInput[2], "x")) - 1, INTEGER(ENTRY(2, cInput[2], "x")) - 1, TRUE).
    ELSE 
        RUN rotate(cInput[2], ENTRY(2, cInput[3], "="), cInput[5]).
END.
INPUT CLOSE.

PROCEDURE createRect:
    DEFINE INPUT  PARAMETER piX   AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piY   AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER plLit AS LOGICAL     NO-UNDO.
    
    DEFINE VARIABLE iX AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iY AS INTEGER     NO-UNDO.

    DO iX = 0 TO piX:
        DO iY = 0 TO piY:
            FIND FIRST ttDisplay WHERE ttDisplay.colX = iX
                                   AND ttDisplay.rowY = iY NO-ERROR.
            IF NOT AVAILABLE ttDisplay THEN DO:
                CREATE ttDisplay.
                ASSIGN 
                    ttDisplay.colX = ix 
                    ttDisplay.rowY = iY.
            END.
            ttDisplay.isLit = plLit.
        END.
    END.
END PROCEDURE.

PROCEDURE rotate:
    DEFINE INPUT  PARAMETER pcTarget AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER piId     AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piRotate AS INTEGER     NO-UNDO.

    DEFINE VARIABLE iRotate AS INTEGER     NO-UNDO.

    /* This if statement can be more efficient and compact but this works... */
    IF pcTarget = "row" THEN DO:
        IF iRotate > {&maxX} THEN
            iRotate = TRUNCATE(piRotate / {&maxX}, 0).
        ELSE 
            iRotate = piRotate.
            
        /* Rotate */
        FOR EACH ttDisplay WHERE ttDisplay.rowY = piID BY ttDisplay.colX DESCENDING:
            ttDisplay.colX = ttDisplay.colX + iRotate.
        END.

        /* Overflowing coordinates will be moved to the beginning */
        FOR EACH ttDisplay WHERE ttDisplay.colX > {&maxX}:
            ttDisplay.colX = ttDisplay.colX - ({&maxX} + 1).
        END.
    END.
    ELSE DO:
        /* We don't have to rotate several turns... */
        IF iRotate > {&maxY} THEN
            iRotate = TRUNCATE(piRotate / {&maxY}, 0).
        ELSE 
            iRotate = piRotate.
            
        /* Rotate */
        FOR EACH ttDisplay WHERE ttDisplay.colX = piID BY ttDisplay.rowY DESCENDING:
            ttDisplay.rowY = ttDisplay.rowY + iRotate.
        END.

        /* Overflowing coordinates will be moved to the beginning */
        FOR EACH ttDisplay WHERE ttDisplay.rowY > {&maxY}:
            ttDisplay.rowY = ttDisplay.rowY - ({&maxY} + 1).
        END.
    END.

END.

FOR EACH ttDisplay WHERE isLit:
    iLit = iLit + 1.
END.


/* This is just to display the message... */
/* Open the file in any editor            */
/* Making this a readable message would be horrible work... */
OUTPUT TO "message.txt".
DO iMaxY = 0 TO {&maxY}:
    DO iMaxX = 0 TO {&maxX}:
        FIND FIRST ttDisplay WHERE ttDisplay.colX = iMaxX 
                               AND ttDisplay.rowY = iMaxY NO-ERROR.

        IF AVAILABLE ttDisplay THEN DO:
    
            IF ttDisplay.isLit THEN 
                PUT UNFORMATTED CHR(219).
            ELSE 
                PUT UNFORMATTED " ".
        END.
    END.
    PUT UNFORMATTED "~n".
END.
OUTPUT CLOSE.

MESSAGE "Num lit:" iLit VIEW-AS ALERT-BOX.
