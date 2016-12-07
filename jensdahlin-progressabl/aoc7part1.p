DEFINE VARIABLE cData      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOutside   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cInside    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lInside    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE iCount     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iEntry     AS INTEGER     NO-UNDO.
DEFINE VARIABLE cEntry     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cChr       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lInsideOK  AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lOutsideOK AS LOGICAL     NO-UNDO.
DEFINE VARIABLE iCountOK   AS INTEGER     NO-UNDO.

FUNCTION containsXYYX RETURNS LOGICAL (INPUT pcString AS CHARACTER) FORWARD.

INPUT FROM VALUE("input7.txt").
REPEAT :

    ASSIGN 
        cInside    = ""
        cOutside   = ""
        lInside    = FALSE
        lInsideOK  = FALSE
        lOutsideOK = FALSE.

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

    insideLoop:
    DO iEntry = 1 TO NUM-ENTRIES(cInside):

        cEntry = ENTRY(iEntry, cInside).

        IF containsXYYX(cEntry) THEN  DO:
            lInsideOK = FALSE.
            LEAVE insideLoop.
        END.
        ELSE 
            lInsideOK = TRUE.

    END.

    /* Only test outside if inside is OK */
    IF lInsideOK THEN DO:
        outsideLoop:
        DO iEntry = 1 TO NUM-ENTRIES(cOutside):
    
            cEntry = ENTRY(iEntry, cOutside).
    
            IF containsXYYX(cOutside) THEN DO:
                lOutsideOK = TRUE.
                LEAVE outsideLoop.
            END.
        END.
    END.
    IF lInsideOK AND lOutsideOK  THEN DO:
        iCountOK = iCountOK + 1.
    END.
    
END.
INPUT CLOSE.

FUNCTION containsXYYX RETURNS LOGICAL (INPUT pcString AS CHARACTER):

    DEFINE VARIABLE iCount AS INTEGER     NO-UNDO.

    IF LENGTH(pcString) < 4 THEN
        RETURN FALSE.

    DO iCount = 4 TO LENGTH(pcString).

        IF  SUBSTRING(pcString, iCount    , 1) =  SUBSTRING(pcString, iCount - 3, 1) 
        AND SUBSTRING(pcString, iCount - 1, 1) =  SUBSTRING(pcString, iCount - 2, 1) 
        AND substring(pcString, iCount    , 1) <> SUBSTRING(pcString, iCount - 1, 1) THEN DO:
            RETURN TRUE.
        END.
    END.

    RETURN FALSE.
END.


MESSAGE "Num OK: " iCountOK VIEW-AS ALERT-BOX.
