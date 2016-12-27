DEFINE VARIABLE cRow   AS CHARACTER   NO-UNDO EXTENT 40.
DEFINE VARIABLE cTraps AS CHARACTER   NO-UNDO INIT "^^.,.^^,^..,..^".
DEFINE VARIABLE iRow   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPos   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSafe  AS INTEGER     NO-UNDO.

FUNCTION triplet RETURNS CHARACTER ( INPUT piRow AS INTEGER
                                   , INPUT piPosition AS INTEGER):

    DEFINE VARIABLE cTriplet AS CHARACTER   NO-UNDO.

    IF piPosition = 1 THEN
        cTriplet = ".".
    ELSE 
        cTriplet = SUBSTRING(cRow[piRow - 1], piPosition - 1, 1).

    cTriplet = cTriplet + SUBSTRING(cRow[piRow - 1], piPosition, 1).

    IF piPosition = LENGTH(cRow[1]) THEN
        cTriplet = cTriplet + ".".
    ELSE 
        cTriplet = cTriplet + SUBSTRING(cRow[piRow - 1], piPosition + 1, 1).

    RETURN cTriplet.

END FUNCTION.

FUNCTION getChar RETURNS CHARACTER ( INPUT piRow AS INTEGER
                                   , INPUT piPosition AS INTEGER ):
    DEFINE VARIABLE cTriplet AS CHARACTER   NO-UNDO.
    cTriplet = triplet(piRow, piPosition).

    IF LOOKUP(cTriplet, cTraps) <> 0 THEN
        RETURN "^".
    ELSE 
        RETURN ".".
END FUNCTION.


cRow[1] = "......^.^^.....^^^^^^^^^...^.^..^^.^^^..^.^..^.^^^.^^^^..^^.^.^.....^^^^^..^..^^^..^^.^.^..^^..^^^..".
DO iRow = 2 TO 40:
    DO iPos = 1 TO LENGTH(cRow[1]):
        cRow[iRow] = cRow[iRow] + getChar(iRow, iPos). 
    END.
END.

DO iRow = 1 TO 40:
    DO iPos = 1 TO LENGTH(cRow[1]):
        IF SUBSTRING(cRow[iRow], iPos, 1) = "." THEN
            iSafe = iSafe + 1.
    END.
END.


MESSAGE "Done: " iSafe VIEW-AS ALERT-BOX.
