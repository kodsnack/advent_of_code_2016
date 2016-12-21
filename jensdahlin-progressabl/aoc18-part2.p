DEFINE VARIABLE cIndata AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTraps  AS CHARACTER   NO-UNDO INIT "^^.,.^^,^..,..^".
DEFINE VARIABLE iRow    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPos    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSafe   AS INTEGER     NO-UNDO.
DEFINE VARIABLE cOldRow AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNewRow AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cChr    AS CHARACTER   NO-UNDO.
FUNCTION triplet RETURNS CHARACTER (INPUT piPosition AS INTEGER):

    DEFINE VARIABLE cTriplet AS CHARACTER   NO-UNDO.

    IF piPosition = 1 THEN
        cTriplet = ".".
    ELSE 
        cTriplet = SUBSTRING(cOldRow, piPosition - 1, 1).

    cTriplet = cTriplet + SUBSTRING(cOldRow, piPosition, 1).

    IF piPosition = LENGTH(cOldRow) THEN
        cTriplet = cTriplet + ".".
    ELSE 
        cTriplet = cTriplet + SUBSTRING(cOldRow, piPosition + 1, 1).

    RETURN cTriplet.

END FUNCTION.

FUNCTION getChar RETURNS CHARACTER ( INPUT piPosition AS INTEGER ):
    DEFINE VARIABLE cTriplet AS CHARACTER   NO-UNDO.
    cTriplet = triplet(piPosition).

    IF LOOKUP(cTriplet, cTraps) <> 0 THEN
        RETURN "^".
    ELSE 
        RETURN ".".
END FUNCTION.

cIndata = "......^.^^.....^^^^^^^^^...^.^..^^.^^^..^.^..^.^^^.^^^^..^^.^.^.....^^^^^..^..^^^..^^.^.^..^^..^^^..".

cOldRow = cIndata.

DO iRow = 2 TO 400000:
    cNewRow = "".
    
    IF iRow MOD 10000 = 0 THEN DO:
        DISP iRow WITH FRAME x1 1 DOWN.
        PAUSE 0.
        PROCESS EVENTS.
    END.
    
    DO iPos = 1 TO 100:
        cChr = getChar(iPos).

        cNewRow = cNewRow + cChr. 
        IF cChr = "." THEN
            iSafe = iSafe + 1.
    END.

    cOldRow = cNewRow.
END.

//First row...
DO iPos = 1 TO LENGTH(cInData):
    IF SUBSTRING(cInData, iPos, 1) = "." THEN
        iSafe = iSafe + 1.
END.

MESSAGE "Done: " iSafe VIEW-AS ALERT-BOX.
