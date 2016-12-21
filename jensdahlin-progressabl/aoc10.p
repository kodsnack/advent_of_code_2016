DEFINE TEMP-TABLE ttEntity NO-UNDO
    FIELD id      AS CHARACTER
    FIELD lowTo   AS CHARACTER
    FIELD highTo  AS CHARACTER
    FIELD value1  AS INTEGER
    FIELD value2  AS INTEGER
    INDEX ind1 id
    INDEX ind2 value1 value2 .

FUNCTION out RETURNS INTEGER (INPUT pcId AS CHARACTER) FORWARD.

DEFINE VARIABLE iOutputs AS INTEGER     NO-UNDO.
DEFINE VARIABLE cRow     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iRules   AS INTEGER     NO-UNDO.
DEFINE VARIABLE lPart1   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lPart2   AS LOGICAL     NO-UNDO.

INPUT FROM VALUE("C:\temp\advent_of_code_2016\advent_of_code_2016\jensdahlin-progressabl\input10.txt").
REPEAT:
    IMPORT UNFORMATTED cRow.

    IF cRow <> ""  THEN DO:
        
        IF cRow BEGINS "bot" THEN DO:
            FIND FIRST ttEntity WHERE ttEntity.id = "bot" + ENTRY(2, cRow, " ") NO-ERROR.
            IF NOT AVAILABLE ttEntity THEN DO:
                CREATE ttEntity.
                ASSIGN ttEntity.id = "bot" + ENTRY(2, cRow, " ").
            END.
            ASSIGN 
                ttEntity.lowTo  = ENTRY(6, cRow, " ") + ENTRY(7, cRow, " ")
                ttEntity.highTo = ENTRY(11, cRow, " ") + ENTRY(12, cRow, " ").
        END.
        ELSE IF cRow BEGINS "value" THEN DO:
            FIND FIRST ttEntity WHERE ttEntity.id = ENTRY(5, cRow, " ") + ENTRY(6, cRow, " ") NO-ERROR.
            IF NOT AVAILABLE ttEntity THEN DO:
                CREATE ttEntity.
                ASSIGN ttEntity.id = ENTRY(5, cRow, " ") + ENTRY(6, cRow, " ") .
            END.
    
            IF ttEntity.value1 = 0 THEN
                ttEntity.value1 = INTEGER(ENTRY(2, cRow, " ")).
            ELSE IF ttEntity.value2 = 0 THEN
                ttEntity.value2 = INTEGER(ENTRY(2, cRow, " ")).
            
        END.
    END.
END.
INPUT CLOSE.

/* Start zooming around */
zooming:
REPEAT:
    
    RUN step.

    /* Part 1 solution */
    IF NOT lPart1 THEN DO:
        FIND FIRST ttEntity WHERE (ttEntity.value1 = 61 AND ttEntity.value2 = 17)
                               OR (ttEntity.value1 = 17 AND ttEntity.value2 = 61) NO-ERROR.
        IF AVAILABLE ttEntity THEN DO:
            DISP "Bot:" ttEntity.id.
            lPart1 = TRUE.
        END.
    END.
    /* Part 2 solution */
    IF NOT lPart2 THEN DO:
        iOutputs = out("0") * out("1") * out("2").
        IF ioutputs > 0 THEN DO:
            DISP iOutputs.
            lPart2 = TRUE.
        END.
    END.
    IF lPart1 AND lPart2 THEN
        LEAVE zooming.
END.



PROCEDURE step:

    DEFINE BUFFER bLow FOR ttEntity.
    DEFINE BUFFER bHigh FOR ttEntity.
    DEFINE BUFFER bOutput FOR ttEntity.

    DEFINE VARIABLE iHigh AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iLow  AS INTEGER     NO-UNDO.

    FIND FIRST ttEntity WHERE ttEntity.value1  > 0 
                          AND ttEntity.value2  > 0 NO-ERROR.
    IF AVAILABLE ttEntity THEN DO:

        FIND FIRST bLow  WHERE bLow.id  = ttEntity.LowTo NO-ERROR.
        FIND FIRST bHigh WHERE bHigh.id = ttEntity.HighTo NO-ERROR.

        IF ttEntity.value1 > ttEntity.value2 THEN
            ASSIGN 
                iHigh = ttEntity.value1
                iLow  = ttEntity.value2.
        ELSE IF ttEntity.value1 < ttEntity.value2 THEN
            ASSIGN
                iLow  = ttEntity.value1
                iHigh = ttEntity.value2.
        
        IF iLow > 0 AND NOT AVAILABLE bLow THEN DO:
            CREATE bLow.
            ASSIGN 
                bLow.id     = ttEntity.lowTo
                bLow.value1 = iLow.
            NEXT.
        END.

        IF iHigh > 0 AND NOT AVAILABLE bHigh THEN DO:
            CREATE bHigh.
            ASSIGN 
                bHigh.id     = ttEntity.highTo
                bHigh.value1 = iHigh.
            NEXT.
        END.

        
        IF AVAILABLE bLow AND bLow.id BEGINS "bot" THEN DO:
            IF bLow.value1 = 0 THEN DO:
                ASSIGN bLow.value1 = iLow.
            END.
            ELSE IF bLow.value2 = 0 THEN DO:
                ASSIGN bLow.value2 = iLow.
            END.
        END.
        
        IF AVAILABLE bHigh AND bHigh.id BEGINS "bot" THEN DO:
            IF bHigh.value1 = 0 THEN DO:
                ASSIGN bHigh.value1 = iHigh.
            END.
            ELSE IF bHigh.value2 = 0 THEN DO:
                ASSIGN bHigh.value2 = iHigh.
            END.
        END.

        ASSIGN 
            ttEntity.value1 = 0
            ttEntity.value2 = 0.
    END.
END.

FUNCTION out RETURNS INTEGER (INPUT pcId AS CHARACTER):
    DEFINE BUFFER b FOR ttEntity.
    FIND FIRST b WHERE b.id = "output" + pcId NO-ERROR.
    IF AVAILABLE b THEN 
        RETURN b.value1.
    ELSE 
        RETURN 0.

END FUNCTION.
