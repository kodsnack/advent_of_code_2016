DEFINE VARIABLE iMax     AS INT64       NO-UNDO INIT 4294967295.
DEFINE VARIABLE iOK      AS INT64       NO-UNDO.
DEFINE VARIABLE iDeleted AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLastTO  AS INT64       NO-UNDO.
DEFINE VARIABLE iDiff    AS int64       NO-UNDO.


DEFINE TEMP-TABLE ttRawBlacklist NO-UNDO
    FIELD frIP AS INT64
    FIELD toIP AS INT64
    FIELD num  AS INTEGER
    INDEX id1 frIP toIP
    INDEX id2 num.

DEFINE BUFFER b FOR ttRawBlacklist.

INPUT FROM VALUE("input20.txt").
REPEAT:
    CREATE ttRawBlacklist.
    IMPORT DELIMITER "-" ttRawBlackList.
END.
INPUT CLOSE.

/* For all optimizing below: repeat until no more matches */

/* Simply delete smaller ranges */
concatLoop:
REPEAT:

    iDeleted = 0.
    FOR EACH ttRawBlackList BY ttRawBlackList.frIP BY ttRawBlackList.toIP.
        FIND FIRST b WHERE b.frIP >= ttRawBlackList.frIP
                       AND b.toIP <= ttRawBlackList.toIP
                       AND ROWID(b) <> ROWID(ttRawBlackList) NO-ERROR.
        IF AVAILABLE b THEN DO:
            DELETE b.
            iDeleted = iDeleted + 1.
        END.
    END.

    IF iDeleted = 0 THEN LEAVE conCatLoop.
END.

/* Increase "to" if there are ranges where "from" is within another range */
toLoop:
REPEAT:
    iDeleted = 0.
    FOR EACH ttRawBlackList BY ttRawBlackList.frIP BY ttRawBlackList.toIP.
        FIND FIRST b WHERE b.frIP >= ttRawBlackList.frIP
                       AND b.frIP <= ttRawBlackList.toIP
                       AND ROWID(b) <> ROWID(ttRawBlackList) NO-ERROR.
        IF AVAILABLE b THEN DO:
            ASSIGN 
                ttRawBlackList.toIp = b.toIP.

            DELETE b.
            iDeleted = iDeleted + 1.
        END.
    END.
    IF iDeleted = 0 THEN LEAVE toLoop.
END.

/* Increase "from" if there are ranges where "to" is within another range */
fromLoop:
REPEAT:
    iDeleted = 0.
    FOR EACH ttRawBlackList BY ttRawBlackList.frIP BY ttRawBlackList.toIP.
        FIND FIRST b WHERE b.toIP >= ttRawBlackList.frIP
                       AND b.toIP <= ttRawBlackList.toIP
                       AND ROWID(b) <> ROWID(ttRawBlackList) NO-ERROR.
        IF AVAILABLE b THEN DO:
            ASSIGN 
                ttRawBlackList.frIp = b.frIP.
            DELETE b.
            iDeleted = iDeleted + 1.
        END.
    END.
    IF iDeleted = 0 THEN LEAVE fromLoop.
END.

/* Count diffs */
FOR EACH ttRawBlackList NO-LOCK BY ttRawBlacklist.toIP:

    IF iLastTo > 0 AND ttRawBlackList.frIp <> iLastTo + 1 THEN
        iDiff = iDiff + (ttRawBlackList.frIP - iLastTo - 1).
    
    iLastTo = ttRawBlackList.toIP.
    
END.

MESSAGE "Answer: " iDiff VIEW-AS ALERT-BOX.

