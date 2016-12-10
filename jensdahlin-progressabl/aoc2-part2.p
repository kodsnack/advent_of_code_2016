/*
Advent of code day 2 2016
*/

/* This is a temp-table definition of the keypads with row and columns */
/*
  C 12345
R /-------\
1 |   1   |
2 |  234  |
3 | 56789 |
4 |  ABC  |
5 |   D   |
  \-------/
*/
DEFINE TEMP-TABLE ttKey NO-UNDO
    FIELD keyRow   AS INTEGER
    FIELD keyCol   AS INTEGER
    FIELD keyValue AS CHARACTER
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

DEFINE VARIABLE cKeys AS CHARACTER   NO-UNDO EXTENT 25 INITIAL 
    ["_","_","1","_","_",
     "_","2","3","4","_",
     "5","6","7","8","9",
     "_","A","B","C","_",
     "_","_","D","_","_"].



/* Create the keys */
DO iRow = 1 TO 5:
    DO iCol = 1 TO 5:
        iValue = iValue + 1.
        CREATE ttKey.
        ASSIGN            
            ttKey.keyRow   = iRow
            ttKey.keyCol   = iCol
            ttKey.keyValue = cKeys[iValue].
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
           
            /* Move! */
            FIND FIRST ttKey NO-LOCK WHERE ttKey.keyRow = iRow + ttMove.rowMove
                                       AND ttKey.keyCol = iCol + ttMove.colMove NO-ERROR.
            IF AVAILABLE ttKey AND ttKey.keyValue <> "_" THEN
                ASSIGN
                    iCol = iCol + ttMove.colMove
                    iRow = iRow + ttMove.rowMove.

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
