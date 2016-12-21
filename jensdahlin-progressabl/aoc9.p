DEFINE VARIABLE  cData AS LONGCHAR   NO-UNDO.

DEFINE VARIABLE iStep        AS INTEGER     NO-UNDO.
DEFINE VARIABLE iStepForward AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLength      AS INTEGER     NO-UNDO.
DEFINE VARIABLE cChunk       AS LONGCHAR   NO-UNDO.

COPY-LOB FROM FILE "C:\temp\advent_of_code_2016\advent_of_code_2016\jensdahlin-progressabl\input9.txt" TO cData.

step:
DO iStep = 1 TO LENGTH(cData).

    IF SUBSTRING(cData, iSTep, 1) = "(" THEN DO:
        RUN decompress(SUBSTRING(cData, iStep) , OUTPUT cChunk, OUTPUT iStepForward).

        iLength = iLength + LENGTH(cChunk).

        iStep = iStep + iStepForward.
        NEXT step.
    END.
    ELSE DO:
        iLength = iLength + 1.
    END.

END.

MESSAGE "Decompressed length: " iLength VIEW-AS ALERT-BOX.

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
