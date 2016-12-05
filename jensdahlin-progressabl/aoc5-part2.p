DEFINE VARIABLE iCounter  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cInput    AS CHARACTER   NO-UNDO INIT "wtnhxymk".
DEFINE VARIABLE cString   AS LONGCHAR    NO-UNDO.
DEFINE VARIABLE cPassword AS CHARACTER   NO-UNDO INIT "********".
DEFINE VARIABLE rVar      AS RAW         NO-UNDO.
DEFINE VARIABLE iPosition AS INTEGER     NO-UNDO.

hashLoop:
REPEAT:
    iCounter = iCounter + 1.
    
    cString = cInput + STRING(iCounter).

    rVar = MD5-DIGEST(cString).
    
    IF STRING(HEX-ENCODE(rVar)) BEGINS "00000" THEN  DO:

        iPosition = ?.
        iPosition = INTEGER(SUBSTRING(STRING(HEX-ENCODE(rVar)), 6, 1)) NO-ERROR.

        IF iPosition <> ? AND iPosition >= 0 AND iPosition <= 7 THEN DO:
        
            iPosition = iPosition + 1.

            IF SUBSTRING(cPassword, iPosition, 1) = "*" THEN 
                SUBSTRING(cPassword, iPosition, 1) = SUBSTRING(STRING(HEX-ENCODE(rVar)), 7, 1).
        END.
    END.

    IF INDEX(cPassword, "*") = 0 THEN LEAVE hashLoop.
END.

MESSAGE "Done, password is: " cPassword VIEW-AS ALERT-BOX.
