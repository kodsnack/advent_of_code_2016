/* AOC 2016 - day 3 - problem 2 */
/* The pain of trying to get the currect answer with only a part of the input file... */
DEFINE TEMP-TABLE ttTriangle NO-UNDO
    FIELD sides AS INTEGER EXTENT 3
    FIELD triangle AS INTEGER
    FIELD nr       AS INTEGER
    INDEX id1 triangle nr.

/* Buffers to the temp-table for individual use */
DEFINE BUFFER bSide1 FOR ttTriangle.
DEFINE BUFFER bSide2 FOR ttTriangle.
DEFINE BUFFER bSide3 FOR ttTriangle.

DEFINE VARIABLE iSide   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCount AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTri   AS INTEGER     NO-UNDO INIT 1.
DEFINE VARIABLE iOK    AS INTEGER     NO-UNDO.

/* Read the input from the file to a temporary table */
INPUT FROM VALUE("input3.txt").
REPEAT :
    CREATE ttTriangle.
    IMPORT ttTriangle.

    iCount = iCount + 1.

    ASSIGN 
        ttTriangle.triangle = iTri
        ttTriangle.nr       = iCount.

    IF iCount MOD 3 = 0 THEN
        ASSIGN 
            iTri   = Tri + 1
            iCount = 0.
END.
INPUT CLOSE.

/* Delete stray input... */
FOR EACH ttTriangle WHERE nr = 0:
    DELETE TtTriangle.
END.


/* Go through the triangles and test if they are correct */
FOR EACH ttTriangle BREAK BY ttTriangle.triangle:

    IF FIRST-OF(ttTriangle.triangle) THEN DO:
        
        FIND FIRST bSide1 WHERE bSide1.tri = ttTriangle.tri
                            AND bSide1.nr  = 1.
        
        FIND FIRST bSide2 WHERE bSide2.tri = ttTriangle.tri
                            AND bSide2.nr  = 2.
        
        FIND FIRST bSide3 WHERE bSide3.tri = ttTriangle.tri
                            AND bSide3.nr  = 3.
        
        DO iSide = 1 TO EXTENT(ttTriangle.sides):
            
            IF  bSide1.sides[iSide] + bSide2.sides[iSide] > bSide3.sides[iSide] 
            AND bSide2.sides[iSide] + bSide3.sides[iSide] > bSide1.sides[iSide] 
            AND bSide3.sides[iSide] + bSide1.sides[iSide] > bSide2.sides[iSide] THEN
                iOK = iOK + 1.
            
        END.
    END.
END.

MESSAGE "Correct triangles:" iOK VIEW-AS ALERT-BOX.
