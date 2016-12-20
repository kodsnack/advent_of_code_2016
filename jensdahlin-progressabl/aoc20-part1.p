DEFINE VARIABLE iMax AS INT64       NO-UNDO INIT 4294967295.
DEFINE VARIABLE iNum AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttRawBlacklist NO-UNDO
    FIELD frIP AS INT64
    FIELD toIP AS INT64
    INDEX id1 frIP toIP.

INPUT FROM VALUE("input20.txt").
REPEAT:

    CREATE ttRawBlacklist.
    IMPORT DELIMITER "-" ttRawBlackList.

END.
INPUT CLOSE.

findNumber:
DO iNum = 1 TO iMax:

    IF iNum MOD 1000 = 0 THEN DO:

    END.
    FIND FIRST ttRawBlackList WHERE frIp <= iNum
                                AND toIp >= iNum NO-ERROR.
    IF NOT AVAILABLE ttRawBlackList THEN DO:
        MESSAGE "Answer: " iNum VIEW-AS ALERT-BOX.
        LEAVE findNumber.
    END.
    ELSE DO:
        /* Skip ahead? */
        IF ttRawBlackList.toIP > iNum THEN
            iNum = ttRawBlackList.toIP.
    END.
END.

