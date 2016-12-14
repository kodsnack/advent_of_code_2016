DEFINE VARIABLE iHash      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCounter   AS INTEGER     NO-UNDO.
DEFINE VARIABLE cSalt      AS CHARACTER   NO-UNDO INIT "ahsbgdzn".
DEFINE VARIABLE cString    AS LONGCHAR    NO-UNDO.
DEFINE VARIABLE cHex       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iKeys      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iAnswer    AS INTEGER     NO-UNDO.
DEFINE VARIABLE cCharacter AS CHARACTER   NO-UNDO.

/* Temp-table to store keys - complete as well as incomplete */
DEFINE TEMP-TABLE ttKey NO-UNDO
    FIELD keyChar  AS CHARACTER
    FIELD rowThree AS INTEGER
    FIELD rowFive  AS INTEGER
    INDEX id rowThree rowFive.

/* If theres any 3 characters in a row - return that character. Otherwise return blank. */
FUNCTION containsThree RETURNS CHARACTER ( INPUT pcString AS CHARACTER ):
    
    DEFINE VARIABLE iLength    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cCharacter AS CHARACTER   NO-UNDO.

    DO iLength = 1 TO LENGTH(pcString) - 2:
        
        IF  SUBSTRING(pcString, iLength, 1) = SUBSTRING(pcString, iLength + 1, 1) 
        AND SUBSTRING(pcString, iLength, 1) = SUBSTRING(pcString, iLength + 2, 1) THEN DO:
            RETURN SUBSTRING(pcString, iLength, 1).
        END.
    END.
    
    /* No result */
    RETURN "".

END FUNCTION.


/* Does pcString contains five consequtive pcChars? */
FUNCTION containsFive RETURNS LOGICAL ( INPUT pcString AS CHARACTER
                                      , INPUT pcChar   AS CHARACTER ):
    DEFINE VARIABLE cString AS CHARACTER   NO-UNDO.
    
    cString = TRIM(FILL(pcChar, 5)).

    IF pcString MATCHES "*" + cString + "*" THEN
        RETURN TRUE.
    ELSE
        RETURN FALSE.

END.

/* Main loop */
hashLoop:
REPEAT:
    
    cString = cSalt + STRING(iCounter).

    
    cHex = STRING(HEX-ENCODE(MD5-DIGEST(cString))).
    cCharacter = containsThree(cHex).

    IF cCharacter <> "" THEN DO:
        CREATE ttKey.
        ASSIGN 
            ttKey.keyChar  = cCharacter
            ttKey.rowThree = iCounter.
    END.

    FOR EACH ttKey WHERE ttKey.rowThree < iCounter AND ttKey.rowThree >= iCounter - 1000 AND ttKey.rowFive = 0:
        IF containsFive(cHex, ttKey.keyChar) THEN
            ttKey.rowFive = iCounter.
    END.

    /* Just display a counter.... */
    IF iCounter MOD 1000 = 0 THEN DO:
        DISP iCounter WITH FRAME x1 1 DOWN.
        PAUSE 0.
        PROCESS EVENTS.
    END.

    /* Remove too old keys so we dont have to match them */
    IF iCounter > 1000 THEN DO:
        FOR EACH ttKey WHERE ttKey.rowFive = 0 AND ttKey.rowThree < iCounter - 1000:
            DELETE ttKey.
        END.
    END.
    
    
    /* Count correct keys */
    iKeys = 0.
    FOR EACH ttKey WHERE ttKey.rowThree > 0 AND ttKey.rowFive > 0:
        iKeys = iKeys + 1.
        IF iKeys = 64 THEN DO:
            iAnswer = ttKey.rowThree.
            LEAVE hashLoop.
        END.
    END.
    iCounter = iCounter + 1.
END.

MESSAGE "Done. Answer: " iAnswer VIEW-AS ALERT-BOX.
