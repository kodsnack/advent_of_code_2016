DEFINE VARIABLE cData      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOutside   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cInside    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lInside    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE iCount     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iEntry     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cEntry     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iEntryRev  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cChr       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCountOK   AS INTEGER     NO-UNDO.
DEFINE VARIABLE cReversed  AS CHARACTER   NO-UNDO.

FUNCTION returnReversedXYX RETURNS CHARACTER (INPUT pcString AS CHARACTER) FORWARD.


INPUT FROM VALUE("input7.txt").

inputLoop:
REPEAT :

    ASSIGN 
        cInside    = ""
        cOutside   = ""
        lInside    = FALSE.

    IMPORT cData.

    DO iCount = 1 TO LENGTH(cData).

        cChr = SUBSTRING(cData, iCount, 1).

        IF cChr = "[" THEN DO:
            lInside = TRUE.

            IF cOutside <> "" THEN
                cOutside = cOutside + ",".
        END.
        ELSE IF cChr = "]" THEN DO:
            lInside = FALSE.

            IF cInside <> "" THEN
                cInside = cInside + ",".
        END.
        ELSE DO:
        
            IF lInside THEN 
                cInside = cInside + cChr.
            ELSE 
                cOutside = cOutside + cChr.
        END.

    END.

    cInside = TRIM(cInside,",").
    cOutside = TRIM(cOutside,",").

    DO iEntry = 1 TO NUM-ENTRIES(cOutside):

        cReversed = returnReversedXYX(ENTRY(iEntry, cOutside)).

        DO iEntryRev = 1 TO NUM-ENTRIES(cReversed):
            
            IF cInside MATCHES "*" + ENTRY(iEntryRev, cReversed) + "*" THEN DO:
                iCountOK = iCountOK + 1.
                NEXT inputLoop.
            END.
        END.
    END.
    
END.
INPUT CLOSE.

FUNCTION returnReversedXYX RETURNS CHARACTER (INPUT pcString AS CHARACTER):

    DEFINE VARIABLE iCount  AS INTEGER     NO-UNDO.

    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.
    IF LENGTH(pcString) < 3 THEN
        RETURN "".

    DO iCount = 3 TO LENGTH(pcString).

        IF  SUBSTRING(pcString, iCount    , 1) =  SUBSTRING(pcString, iCount - 2, 1) 
        AND SUBSTRING(pcString, iCount    , 1) <> SUBSTRING(pcString, iCount - 1, 1) THEN DO:
            
            cReturn = cReturn + (IF cReturn = "" THEN "" ELSE ",") + SUBSTRING(pcString, iCount - 1, 1) + SUBSTRING(pcString, iCount, 1) + SUBSTRING(pcString, iCount - 1, 1).

        END.
    END.

    RETURN cReturn.
END.


MESSAGE "Num OK: " iCountOK VIEW-AS ALERT-BOX.
