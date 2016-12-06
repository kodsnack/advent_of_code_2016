DEFINE VARIABLE cData    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCounter AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttAscii NO-UNDO
    FIELD pos    AS INTEGER
    FIELD letter AS CHARACTER
    FIELD num    AS INTEGER
    INDEX id1 pos letter.

INPUT FROM VALUE("input6.txt").
REPEAT :
    IMPORT cData.
    
    DO iCounter = 1 TO LENGTH(cData):
        FIND FIRST ttAscii WHERE ttAScii.pos = iCounter
                             AND ttAscii.letter = SUBSTRING(cData, iCounter, 1) NO-ERROR.
        IF NOT AVAILABLE ttAscii THEN DO:
            CREATE ttAscii.
            ASSIGN 
                ttAScii.pos    = iCounter                        
                ttAscii.letter = SUBSTRING(cData, iCounter, 1).
        END.
        ttAscii.num = ttAscii.num + 1.
    END.
END.
INPUT CLOSE.

FOR EACH ttAscii BREAK BY pos BY num DESCENDING:
    IF FIRST-OF(pos) THEN
        DISPLAY ttAscii.pos ttAscii.letter.
END.
