DEFINE TEMP-TABLE ttDisc NO-UNDO
    FIELD discNum AS INTEGER
    FIELD discPositions AS INTEGER
    FIELD discStartPos  AS INTEGER
    FIELD discCurrPos   AS INTEGER.

DEFINE VARIABLE iDiscs     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cDisc      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iPress     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSecond    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTotalSecs AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPosition  AS INTEGER     NO-UNDO.

PROCEDURE rotateDiscs :
    FOR EACH ttDisc BY discCurrPos DESCENDING:

        ttDisc.discCurrPos = ttDisc.discCurrPos + 1.

        IF ttDisc.discCurrPos = ttDisc.discPositions THEN
            ttDisc.discCurrPos = 0.
    END.
END.

// Part 1
/*INPUT FROM "input15.txt".*/
// Part 2 
INPUT FROM "input15-2.txt".
REPEAT :
    IMPORT UNFORMATTED cDisc.
        
    IF cDisc <> "" THEN DO:
        CREATE ttDisc.
        ASSIGN 
            ttDisc.discNum       = INTEGER(SUBSTRING(cDisc, INDEX(cDisc, "#") + 1, 1))
            ttDisc.discPositions = INTEGER(ENTRY(4, cDisc, " "))
            ttDisc.discStartPos  = INTEGER(SUBSTRING(ENTRY(12, cDisc, " "),1,1))
            ttDisc.discCurrPos   = ttDisc.discStartPos.

        iDiscs = iDiscs + 1.
    END.
END.
INPUT CLOSE.

FUNCTION fallThrough RETURNS LOGICAL (INPUT piPosition AS INTEGER) :

    FIND FIRST ttDisc WHERE ttDisc.discNum = piPosition NO-ERROR.
    IF ttDisc.discCurrPos = 0 THEN
        RETURN TRUE.
    ELSE 
        RETURN FALSE.

END FUNCTION.

press:
REPEAT:
    iPress = iPress + 1.
    iPosition = 0.

    DO iSecond = 1 TO iDiscs:

        RUN rotateDiscs.

        iPosition = iPosition + 1.
        iTotalSecs = iTotalSecs + 1.
            
        IF NOT fallThrough(iPosition) THEN NEXT press.

    END.

    LEAVE press.

END.

MESSAGE "Answer:" iTotalSecs - iDiscs VIEW-AS ALERT-BOX.
