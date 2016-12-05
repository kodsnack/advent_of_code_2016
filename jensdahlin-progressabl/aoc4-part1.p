DEFINE TEMP-TABLE ttKey NO-UNDO
    FIELD encName        AS CHARACTER
    FIELD sector         AS INTEGER
    FIELD storedChecksum AS CHARACTER
    FIELD realChecksum   AS CHARACTER.

DEFINE TEMP-TABLE ttFreq NO-UNDO
    FIELD letter AS CHARACTER
    FIELD num    AS INTEGER
    INDEX id1 letter
    INDEX srt num letter.
    

DEFINE VARIABLE cData   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPart   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iLetter AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSum    AS INTEGER     NO-UNDO.

INPUT FROM VALUE("C:\temp\advent_of_code_2016\advent_of_code_2016\jensdahlin-progressabl\input4.txt").
REPEAT:
    IMPORT cData .

    /* Part of data = encode + sector */
    cPart = SUBSTRING(cData, 1, INDEX(cData, "[") - 1).

    /* Create record of key */
    CREATE ttKey.
    ASSIGN 
        ttKey.encName  = REPLACE(SUBSTRING(cPart, 1, R-INDEX(cData, "-") - 1),"-","")
        ttkey.sector   = INTEGER(SUBSTRING(cPart, R-INDEX(cData, "-") + 1))
        ttKey.storedCheckSum = SUBSTRING(cData, INDEX(cData, "[") + 1, 5).  
END.
INPUT CLOSE.

/* Calculate checksums and sum */
FOR EACH ttKey:
    EMPTY TEMP-TABLE ttFreq.

    DO iLetter = 1 TO LENGTH(ttKey.encName).
        FIND FIRST ttFreq WHERE ttFreq.letter = SUBSTRING(ttKey.encName, iLetter, 1) NO-ERROR.
        IF NOT AVAILABLE ttFreq THEN DO:
            CREATE ttFreq.
            ASSIGN ttFreq.letter = SUBSTRING(ttKey.encName, iLetter, 1).
        END.
        ttFreq.num = ttFreq.num + 1.
    END.

    FOR EACH ttFreq NO-LOCK BY ttFreq.num DESCENDING BY ttFreq.letter iLetter = 1 TO 5:
        ttKey.realChecksum = ttKey.realChecksum + ttFreq.letter.
    END.

    IF ttKey.storedChecksum = ttKey.realChecksum THEN
        iSum = iSum + ttKey.sector.
END.

MESSAGE "Sum: " iSum VIEW-AS ALERT-BOX.
