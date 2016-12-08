DEFINE TEMP-TABLE ttDisplay NO-UNDO
    FIELD colX  AS INTEGER
    FIELD rowY  AS INTEGER
    FIELD isLit AS LOGICAL
    INDEX id1 colX rowY.
DEFINE VARIABLE iLit   AS INTEGER     NO-UNDO.
DEFINE VARIABLE cInput AS CHARACTER   NO-UNDO EXTENT 5.

INPUT FROM VALUE("C:\temp\aoc2016\advent_of_code_2016\jensdahlin-progressabl\input8.txt").
REPEAT:
    IMPORT cInput.

    DISP cInput.

    IF cInput[1] = "rect" THEN
        RUN createRect(cInput[2]).
    ELSE 
        RUN rotateRect(cInput[2], ENTRY(2, cInput[3], "="), cInput[5]).
    
END.
INPUT CLOSE.

PROCEDURE createRect:
    DEFINE INPUT  PARAMETER pcXbyY AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iX AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iY AS INTEGER     NO-UNDO.

    DO iX = 0 TO INTEGER(ENTRY(1, pcXbyY, "x")) - 1:
        DO iY = 0 TO INTEGER(ENTRY(1, pcXbyY, "x")) - 1:
            FIND FIRST ttDisplay WHERE ttDisplay.colX = ix
                                   AND ttDisplay.rowY = iY NO-ERROR.
            IF NOT AVAILABLE ttDisplay THEN DO:
                CREATE ttDisplay.
                ASSIGN 
                    ttDisplay.colX = ix 
                    ttDisplay.rowY = iY.
            END.
            ttDisplay.isLit = TRUE.
        END.
    END.
END PROCEDURE.

PROCEDURE rotateRect:
    DEFINE INPUT  PARAMETER pcTarget AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER piId     AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piRotate AS INTEGER     NO-UNDO.

    IF pcTarget = "row" THEN DO:

    END.
    ELSE DO:

    END.
END.

FOR EACH ttDisplay WHERE ttDisplay.isLit:
    iLit = iLit + 1.
END.

DISPLAY iLit.
