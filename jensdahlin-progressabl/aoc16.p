/* Calculate checksum */
FUNCTION checksum RETURNS LONGCHAR (INPUT pcString AS LONGCHAR):

    DEFINE VARIABLE iPairs    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cCheckSum AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE cChr1     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cChr2     AS CHARACTER   NO-UNDO.

    IF LENGTH(pcString) MODULO 2 = 1 THEN DO:
        RETURN pcString.
    END.

    DO iPairs  = 1 TO LENGTH(pcString) BY 2:
        
        cChr1 = SUBSTRING(pcString, iPairs, 1).
        cChr2 = SUBSTRING(pcString, iPairs + 1, 1).

        IF cChr1 = cChr2 THEN 
            cCheckSum = cCheckSum + "1".
        ELSE
            cCheckSum = cCheckSum + "0".

    END.
    //This only works for solution 1. Solution 2 destroys the stack...
    IF LENGTH(cCheckSum) MODULO 2 = 0 THEN
        cCheckSum = checksum(cCheckSum).

    RETURN cCheckSum.
END FUNCTION.



/* Reverse a string (abc = cba) */
FUNCTION reverse RETURNS LONGCHAR (INPUT pcString AS LONGCHAR):

    DEFINE VARIABLE cString AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE iLength AS INTEGER     NO-UNDO.

    DO iLength = LENGTH(pcString) TO 1 BY -1:
        cString = cString + SUBSTRING(pcString, iLength, 1).
    END.

    RETURN cString.
END.

/* Invert 0s and 1s, 0110 = 1001 */
FUNCTION invert RETURNS LONGCHAR (INPUT pcString AS LONGCHAR):

    DEFINE VARIABLE cString AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE iLength AS INTEGER     NO-UNDO.

    DO iLength = 1 TO LENGTH(pcString) :
        cString = cString + (IF SUBSTRING(pcString, iLength, 1) = "0" THEN "1" ELSE "0").
    END.

    RETURN cString.

END.

DEFINE VARIABLE cStartString   AS CHARACTER   NO-UNDO INIT "01111010110010011".
DEFINE VARIABLE cString        AS LONGCHAR    NO-UNDO.
DEFINE VARIABLE iLengthWanted  AS INTEGER     NO-UNDO INIT 272.

/*
//Test values 
DEFINE VARIABLE cString       AS CHARACTER   NO-UNDO INIT "10000".
DEFINE VARIABLE iLengthWanted AS INTEGER     NO-UNDO INIT 20.
*/
DEFINE VARIABLE cCopy         AS LONGCHAR    NO-UNDO.
DEFINE VARIABLE cChecksum     AS LONGCHAR    NO-UNDO.

cString = cStartString.
/* Modified dragon curve */
DO WHILE LENGTH(cString) < iLengthWanted:
    cCopy = invert(reverse(cString)).
    cString = cString + "0" +  cCopy.

END.

/* Calculate the checksum */
cCheckSum = checksum(SUBSTRING(cString, 1, iLengthWanted)).

DISP LENGTH(cCheckSum).

MESSAGE "Solution: " STRING(cCheckSum) VIEW-AS ALERT-BOX.
