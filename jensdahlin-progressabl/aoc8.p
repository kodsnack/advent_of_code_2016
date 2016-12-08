&SCOPED-DEFINE maxY 4
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




INPUT FROM VALUE("C:\temp\advent_of_code_2016\advent_of_code_2016\jensdahlin-progressabl\input8-test.txt").
REPEAT:
    IMPORT cInput.

    DISP cInput.

    IF cInput[1] = "rect" THEN
        RUN createRect(INTEGER(ENTRY(1, cInput[2], "x")) - 1, INTEGER(ENTRY(2, cInput[2], "x")) - 1, TRUE).
    ELSE 
        RUN rotateRect(cInput[2], ENTRY(2, cInput[3], "="), cInput[5]).
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

PROCEDURE rotateRect:
    DEFINE INPUT  PARAMETER pcTarget AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER piId     AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piRotate AS INTEGER     NO-UNDO.

    //DISP pcTarget piId piRotate.

    DEFINE VARIABLE iRotate AS INTEGER     NO-UNDO.

    IF pcTarget = "row" THEN DO:

        DISPLAY pcTarget piId piRotate.

        IF iRotate > {&maxX} THEN
            iRotate = TRUNCATE(piRotate / {&maxX}, 0).
        ELSE 
            iRotate = piRotate.
            
        /* Rotate */
        FOR EACH ttDisplay WHERE ttDisplay.rowY = piID BY ttDisplay.colX DESCENDING:

            ttDisplay.colX = ttDisplay.colX + iRotate.

            /* Overflowing coordinates will be moved to the beginning */
            IF ttDisplay.colX > {&maxX} THEN DO:
                
                //DISP "HEJ" ttDisplay.colX rowY.

                ttDisplay.colX = ttDisplay.colX - ({&maxX} + 1).

                //PAUSE.

                //DISP "HEJDå" ttDisplay.colX  rowY.
            END.
        END.
    END.
    ELSE DO:
        /* We don't have to rotate several turns... */
        IF iRotate > {&maxY} THEN
            iRotate = TRUNCATE(piRotate / {&maxY}, 0).
        ELSE 
            iRotate = piRotate.
            
        /* Rotate */
        FOR EACH ttDisplay WHERE ttDisplay.colX = piID BY ttDisplay.rowY DESC:

            ttDisplay.rowY = ttDisplay.rowY + iRotate.

            /* Overflowing coordinates will be moved to the beginning */
            IF ttDisplay.rowY > {&maxY} THEN DO:
                ttDisplay.rowY = ttDisplay.rowY - ({&maxY} + 1).
            END.
        END.
    END.
END.


OUTPUT TO c:\temp\grid.csv.

DO iMaxY = 0 TO {&maxY}:
    DO iMaxX = 0 TO {&maxX}:
        FIND FIRST ttDisplay WHERE ttDisplay.colX = iMaxX 
                               AND ttDisplay.rowY = iMaxY NO-ERROR.

        IF AVAILABLE ttDisplay THEN DO:
    
            IF ttDisplay.isLit THEN 
                PUT UNFORMATTED "X;".
            ELSE 
                PUT UNFORMATTED "o;".
        END.
    

    END.
    PUT UNFORMATTED SKIP.
END.
OUTPUT CLOSE.

FOR EACH ttDisplay WHERE isLit:

    
    iLit = iLit + 1.

END.

DISPLAY iLit.
