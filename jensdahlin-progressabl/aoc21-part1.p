DEFINE VARIABLE cInput    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCommand  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cArgs     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cScramble AS CHARACTER   NO-UNDO.

 
FUNCTION swapposition RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iFrom AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iTo   AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE cTmp AS CHARACTER   NO-UNDO.
    
    iFrom = INTEGER(ENTRY(1, pcArgs, " ")) + 1.
    iTo   = INTEGER(ENTRY(4, pcArgs, " ")) + 1.

    cReturn = pcString.

    cTmp = SUBSTRING(cReturn, iFrom, 1).
 
    SUBSTRING(cReturn, iFrom, 1) = SUBSTRING(cReturn, iTo, 1).

    SUBSTRING(cReturn, iTo, 1) = cTmp.

    RETURN cReturn.
END FUNCTION.

FUNCTION swapletter RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cSwap1  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cSwap2 AS CHARACTER   NO-UNDO.

     //f with letter e

    ASSIGN
         cSwap1 = ENTRY(1, pcArgs, " ")
         cSwap2 = ENTRY(4, pcArgs, " ").

    cReturn = REPLACE(pcString, cSwap1, "*").
    cReturn = REPLACE(cReturn, cSwap2, cSwap1).
    cReturn = REPLACE(cReturn, "*",    cSwap2).

    RETURN cReturn.

END FUNCTION.

FUNCTION rotateleft RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iSteps  AS INTEGER     NO-UNDO.
    iSteps = INTEGER(ENTRY(1, pcArgs, " ")).
    IF iSteps > LENGTH(pcString) THEN
        iSteps = iSteps MODULO 4.
    IF iSteps = 0 THEN
        RETURN pcString.
    
    // abcd rotate left 1 = bcda
    // abcd rotate left 2 = cdab
    cReturn = SUBSTRING(pcString, iSteps + 1) + SUBSTRING(pcString, 1, iSteps).
    
    RETURN cReturn.
END FUNCTION.

FUNCTION rotateright RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iSteps AS INTEGER     NO-UNDO.

    iSteps = INTEGER(ENTRY(1, pcArgs, " ")).
    IF iSteps > LENGTH(pcString) THEN
        iSteps = iSteps MODULO 4.
    IF iSteps = 0 THEN
        RETURN pcString.
    
    // abcd rotate right 1 = dabc.
    // acbd rotate tight 2 = cdab
    cReturn = SUBSTRING( pcString, LENGTH(pcString) - iSteps + 1) + SUBSTRING( pcString, 1, LENGTH(pcstring) - iSteps).
    
    RETURN cReturn.
END FUNCTION.

FUNCTION rotateposition RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cLetter AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iIndex  AS INTEGER     NO-UNDO.
    
    cLetter = ENTRY(5, pcArgs, " ").
    
    iIndex = INDEX(pcString, cLetter) - 1.

     IF iIndex >= 4 THEN
        iIndex = iIndex + 1.

    iIndex = iIndex + 1.

    RETURN rotateright(pcString, STRING(iIndex)).

END FUNCTION.

FUNCTION reverse RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cReverse AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iReverse AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iStart   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iStop    AS INTEGER     NO-UNDO.
     
    ASSIGN 
        iStart = INTEGER(ENTRY(2, pcArgs, " "))
        iStop  = INTEGER(ENTRY(4, pcArgs, " ")).

    /* First part */
    IF iStart > 0 THEN
        cReturn = SUBSTRING(pcString, 1, iStart).

    /* Reversed middle */
    DO iReverse = iStop + 1 TO iStart + 1 BY -1:
        cReverse = cReverse + SUBSTRING(pcString, iReverse, 1).
    END.
    cReturn = cReturn + cReverse.

    /* Tail */
    IF iStop < LENGTH(pcString) - 1 THEN DO:
        cReturn = cReturn + SUBSTRING(pcString, iStop + 2).
    END.

    RETURN cReturn.
END FUNCTION.

FUNCTION movePos RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iFrom AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iTo   AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE cTmp AS CHARACTER   NO-UNDO.
    
    iFrom = INTEGER(ENTRY(1, pcArgs, " ")) + 1.
    iTo   = INTEGER(ENTRY(4, pcArgs, " ")) + 1.

    cReturn = pcString.

    cTmp = SUBSTRING(cReturn, iFrom, 1).
 
    SUBSTRING(cReturn, iFrom, 1) = "".

    SUBSTRING(cReturn, iTo, 0) = cTmp.


    RETURN cReturn.
END FUNCTION.

DEFINE TEMP-TABLE ttCommand NO-UNDO
    FIELD cmd        AS CHARACTER
    FIELD fun        AS CHARACTER.

/* Command list */
CREATE ttCommand.
ASSIGN 
    ttCommand.cmd        = "move position"
    ttCommand.fun        = "movePos".

CREATE ttCommand.
ASSIGN 
    ttCommand.cmd        = "swap position"
    ttCommand.fun        = "swapposition".

CREATE ttCommand.
ASSIGN 
    ttCommand.cmd        = "swap letter"
    ttCommand.fun        = "swapletter".

CREATE ttCommand.
ASSIGN 
    ttCommand.cmd        = "rotate left"
    ttCommand.fun        = "rotateleft".

CREATE ttCommand.
ASSIGN 
    ttCommand.cmd        = "rotate right"
    ttCommand.fun        = "rotateright".

CREATE ttCommand.
ASSIGN 
    ttCommand.cmd        = "rotate based"
    ttCommand.fun        = "rotateposition".

CREATE ttCommand.
ASSIGN 
    ttCommand.cmd        = "reverse"
    ttCommand.fun        = "reverse".


cInput = "input21.txt".
cScramble = "abcdefgh".
/*
cInput = "input21-test.txt".
cScramble = "abcde".
*/
INPUT FROM VALUE(cInput).
REPEAT :
    IMPORT UNFORMATTED cCommand.
    FIND FIRST ttCommand WHERE cCommand BEGINS ttCommand.cmd NO-ERROR.
    IF AVAILABLE ttCommand THEN DO:
        cScramble = DYNAMIC-FUNCTION(ttCommand.fun, cScramble, TRIM(SUBSTRING(cCommand, LENGTH(ttCommand.cmd) + 1))).
    END.                                  
END.
INPUT CLOSE.



MESSAGE "Done:" cScramble VIEW-AS ALERT-BOX.
