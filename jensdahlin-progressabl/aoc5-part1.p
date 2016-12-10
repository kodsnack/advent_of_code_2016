DEFINE VARIABLE iCounter  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cInput    AS CHARACTER   NO-UNDO INIT "wtnhxymk".
DEFINE VARIABLE cString   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE cPassword AS CHARACTER   NO-UNDO.
DEFINE VARIABLE rVar      AS RAW NO-UNDO.

hashLoop:
REPEAT:
    iCounter = iCounter + 1.
    
    cString = cInput + STRING(iCounter).

    rVar = MD5-DIGEST(cString).
    
    IF STRING(HEX-ENCODE(rVar)) BEGINS "00000" THEN  DO:
        cPassword = cPassword + SUBSTRING(STRING(HEX-ENCODE(rVar)), 6, 1).
        DISP cPassword.
    END.

    IF LENGTH(cPassword) = 8 THEN LEAVE hashLoop.
END.

MESSAGE "Done, password is: " cPassword VIEW-AS ALERT-BOX.
