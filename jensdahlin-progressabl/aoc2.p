/* This is a temp-table definition of the keypads with row and columns */

/*
  C 123
R /-----\
1 | 123 |
2 | 456 |
3 | 789 |
  \-----/
*/
DEFINE TEMP-TABLE ttKey NO-UNDO
    FIELD keyRow   AS INTEGER
    FIELD keyCol   AS INTEGER
    FIELD keyValue AS INTEGER
    INDEX id1 keyRow keyCol.

/* For storing move-instructions */
DEFINE TEMP-TABLE ttMove NO-UNDO
    FIELD moveChar  AS CHARACTER
    FIELD rowMove AS INTEGER
    FIELD colMove AS INTEGER.

DEFINE VARIABLE iRow          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCol          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iValue        AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMoves        AS INTEGER     NO-UNDO.
DEFINE VARIABLE cMove         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cInstructions AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCode         AS CHARACTER   NO-UNDO.


/* Create the keys */
DO iRow = 1 TO 3:
    DO iCol = 1 TO 3:
        iValue = iValue + 1.
        CREATE ttKey.
        ASSIGN            
            ttKey.keyRow   = iRow
            ttKey.keyCol   = iCol
            ttKey.keyValue = iValue.
    END.
END.

/* Procedure for creating move instructions */
PROCEDURE createMove :
    DEFINE INPUT  PARAMETER pcMove     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER piRowMove  AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER piColmove  AS INTEGER     NO-UNDO.

    CREATE ttMove.
    ASSIGN 
        ttMove.moveChar = pcMove
        ttMove.rowMove  = piRowMove
        ttMove.colMove  = piColMove.

END PROCEDURE.

RUN createMove("U", -1,  0).
RUN createMove("D",  1,  0).
RUN createMove("L",  0, -1).
RUN createMove("R",  0,  1).


/* Read the file and iterate for every row in the file */
INPUT FROM VALUE("input2.txt").
REPEAT:
    /* Import the row of data */
    IMPORT cInstructions.

    /* Reset keypad posistion to 5 (col = 2, row = 2). */
    ASSIGN 
        iCol = 2
        iRow = 2.

    /* Now move! */
    DO iMoves = 1 TO LENGTH(cInstructions).
        /* Get the instruction */
        cMove = SUBSTRING(cInstructions, iMoves, 1).
        
        /* Find the move pattern for this instruction */
        FIND FIRST ttMove WHERE ttMove.moveChar = cMove NO-ERROR.
        IF AVAILABLE ttMove THEN DO:
           
            /* Move the columns */
            iCol = iCol + ttMove.colMove.

            /* But dont move too far */
            IF iCol = 0 THEN
                iCol = 1.
            ELSE IF iCol = 4 THEN
                iCol = 3.

            /* Move the rows */
            iRow = iRow + ttMove.rowMove.
            
            /* But dont move too far */
            IF iRow = 0 THEN
                iRow = 1.
            ELSE IF iRow = 4 THEN
                iRow = 3.

            /* Only at the last instruction we need to decode to the actual value */
            IF iMoves = LENGTH(cInstructions) THEN DO:
                FIND FIRST ttKey WHERE ttKey.keyRow = iRow
                                   AND ttKey.keyCol = iCol NO-ERROR.
                IF AVAILABLE ttKey THEN DO:
                    cCode = cCode + STRING(ttKey.keyValue).
                END.
            END.
        END.
    END.
END.
INPUT CLOSE.

/* Display result */
MESSAGE "The code is " cCode VIEW-AS ALERT-BOX.
