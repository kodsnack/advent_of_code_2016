DEFINE VARIABLE cInput    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCommand  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cArgs     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cScramble AS CHARACTER   NO-UNDO INIT "abcdefgh".

 
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


    RETURN cReturn.
END FUNCTION.

FUNCTION rotateleft RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.


    RETURN cReturn.
END FUNCTION.

FUNCTION rotateright RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iSteps AS INTEGER     NO-UNDO.

    DISP pcArgs pcString.

    iSteps = INTEGER(ENTRY(1, pcArgs, " ")).
    IF iSteps > LENGTH(pcString) THEN
        iSteps = iSteps MODULO 4.
    IF iSteps = 0 THEN
        RETURN pcString.
    
    cReturn = SUBSTRING(pcString, LENGTH(pcString) - iSteps + 1) + SUBSTRING(pcString, 1, iSteps).
    
    DISP cReturn FORMAT "x(30)".
    
    RETURN cReturn.
END FUNCTION.

FUNCTION rotateposition RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.


    RETURN cReturn.
END FUNCTION.

FUNCTION reverse RETURNS CHARACTER (INPUT pcString AS CHARACTER, INPUT pcArgs AS CHARACTER).
    DEFINE VARIABLE cReturn AS CHARACTER   NO-UNDO.


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

    SUBSTRING(cReturn, iTo, 1) = cTmp.

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
    ttCommand.cmd        = "rotate left"
    ttCommand.fun        = "rotateleft".

CREATE ttCommand.
ASSIGN 
    ttCommand.cmd        = "rotate right"
    ttCommand.fun        = "rotateright".

cInput = "C:\temp\aoc2016\advent_of_code_2016\jensdahlin-progressabl\input21.txt".


DISPLAY rotateright("abcd", "1 steps").
INPUT FROM VALUE(cInput).
REPEAT :
    IMPORT UNFORMATTED cCommand.
    
    FIND FIRST ttCommand WHERE cCommand BEGINS ttCommand.cmd NO-ERROR.
    IF AVAILABLE ttCommand THEN DO:
        cScramble = DYNAMIC-FUNCTION(ttCommand.fun, cScramble, TRIM(SUBSTRING(cCommand, LENGTH(ttCommand.cmd) + 1))).
    END.                                  
    ELSE DO:
    END.

END.
INPUT CLOSE.



MESSAGE "Done".
