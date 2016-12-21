DEFINE VARIABLE  cData AS LONGCHAR   NO-UNDO.

DEFINE VARIABLE iStep        AS INTEGER     NO-UNDO.

DEFINE VARIABLE iSize        AS INTEGER     NO-UNDO.
DEFINE VARIABLE cChunk       AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE iDecompSize  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cHeader      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iLen         AS INTEGER     NO-UNDO.
DEFINE VARIABLE cTail        AS CHARACTER   NO-UNDO.

//COPY-LOB FROM FILE "C:\temp\aoc2016\advent_of_code_2016\jensdahlin-progressabl\input9.txt" TO cData.

cData = "X(8x2)(3x3)ABCY".

FUNCTION decompress RETURNS INTEGER (INPUT pcData AS LONGCHAR):
    

    DISP string(pcData) FORMAT "x(30)".
    DEFINE VARIABLE iSize AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE iStepForward AS INTEGER     NO-UNDO.
    step:
    DO iStep = 1 TO LENGTH(pcData).
    
        IF SUBSTRING(pcData, iSTep, 1) = "(" THEN DO:
    
             
            cHeader = SUBSTRING(pcData, iStep + 1, INDEX(pcData, ")", iStep) - iStep - 1).
    
            iLen = INTEGER(ENTRY(1, cHeader, "x")).
           
            cTail   = SUBSTRING(pcData, INDEX(pcData, ")", iStep) + 1, iLen).

            IF INDEX(cTail, "(") = 0 THEN
                iDecompSize =  INTEGER(ENTRY(2, cHeader, "x")) * LENGTH(cTail).
            ELSE 
                iDecompSize =  INTEGER(ENTRY(2, cHeader, "x")) * decompress(cTail).

            iSize = iSize + iDecompSize.
            iStepForward = LENGTH(cHeader) + iLen + 1.

            iStep = iStep + iStepForward.
            NEXT step.
        END.
        ELSE DO:
            iSize = iSize + 1.
        END.
    
    END.

    RETURN iSize. 
END FUNCTION.

MESSAGE "Size: " decompress(INPUT cData) VIEW-AS ALERT-BOX.

/*
PROCEDURE decompress:
    DEFINE INPUT  PARAMETER pcData    AS LONGCHAR    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcChunk   AS LONGCHAR   NO-UNDO.
    DEFINE OUTPUT PARAMETER piForward AS INTEGER     NO-UNDO.

    DEFINE VARIABLE cParenthesis AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iLength      AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iRepeats     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iCount       AS INTEGER     NO-UNDO INIT 1.
    DEFINE VARIABLE cString      AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE cNewChunk    AS LONGCHAR    NO-UNDO.
    DEFINE VARIABLE iTmpForward  AS INTEGER     NO-UNDO.
    /* Get first (AxB) occurance */
    ASSIGN 
        cParenthesis = SUBSTRING(pcData, 2, INDEX( pcData, ")") - 2)
        iLength  = INTEGER(ENTRY(1, cParenthesis, "x"))
        iRepeats = INTEGER(ENTRY(2, cParenthesis, "x")).

    cString = SUBSTRING(pcData, INDEX(pcData, ")") + 1, iLength).

    DO iCount = iCount TO iRepeats.
        pcChunk = pcChunk + cString.
    END.

    IF piForward = 0 THEN
        ASSIGN      
            piForward = LENGTH(SUBSTRING(pcData, 2, INDEX( pcData, ")") - 2)) +  iLength + 1.
END.
*/
