DEFINE TEMP-TABLE ttReg NO-UNDO
    FIELD reg AS CHARACTER
    FIELD val AS INTEGER
    INDEX id1 reg.

DEFINE VARIABLE cInstr   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iPointer AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttInstr NO-UNDO
    FIELD instr    AS CHARACTER
    FIELD reg      AS CHARACTER
    FIELD instrNum AS INTEGER
    INDEX id1 instrNum.

/* Initialize registers */
CREATE ttReg.
ASSIGN ttReg.reg = "a".

CREATE ttReg.
ASSIGN ttReg.reg = "b".

CREATE ttReg.
ASSIGN ttReg.reg = "c".

/* Part 2  - uncomment below*/
ttReg.val = 1.

CREATE ttReg.
ASSIGN ttReg.reg = "d".

INPUT FROM "input12.txt".
REPEAT:
    CREATE ttInstr.
    IMPORT UNFORMATTED ttInstr.instr.

    IF ttInstr.instr BEGINS "cpy" THEN
        ttInstr.reg = ENTRY(3, ttInstr.instr,  " ").
    ELSE 
        ttInstr.reg = ENTRY(2, ttInstr.instr,  " ").

    iPointer = iPointer + 1.
    ttInstr.instrNum = iPointer.

END.
INPUT CLOSE.

/* Reset pointer */
iPointer = 1.


exec:
REPEAT:

    FIND FIRST ttInstr WHERE ttInstr.instrNum = iPointer NO-ERROR.
    IF AVAILABLE ttInstr THEN DO:
        cInstr = ENTRY(1, ttInstr.instr, " ").
        RUN VALUE("instr-" + cInstr)  ( INPUT TRIM(SUBSTRING(ttInstr.instr, INDEX(ttInstr.instr, " "))) ). 

        IF cInstr <> "jnz" THEN
            iPointer = iPointer + 1.
    END.
    ELSE 
        LEAVE exec.

END.

FIND FIRST ttReg WHERE ttReg.reg = "a".

MESSAGE "Value of reg a: " ttReg.val VIEW-AS ALERT-BOX INFO.

PROCEDURE instr-cpy:
    DEFINE INPUT  PARAMETER pcData AS CHARACTER   NO-UNDO.

    DEFINE BUFFER bFrom FOR ttReg.
    DEFINE BUFFER bTo   FOR ttReg. 

    DEFINE VARIABLE iValue AS INTEGER     NO-UNDO.

    FIND FIRST bFrom WHERE bFrom.reg = TRIM(ENTRY(1, pcData, " ")) NO-ERROR.
    IF AVAILABLE bFrom THEN DO:
        iValue = bFrom.val.
    END.
    ELSE DO:
        iValue = INTEGER(TRIM(ENTRY(1, pcData, " "))).
    END.

    FIND FIRST bTo WHERE bTo.reg = TRIM(ENTRY(2, pcData, " ")) NO-ERROR.
    IF AVAILABLE bTo THEN
        bTo.val = iValue.

END.
PROCEDURE instr-jnz:
    DEFINE INPUT  PARAMETER pcData AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE iVal AS INTEGER     NO-UNDO.

    FIND FIRST ttReg WHERE ttReg.reg = TRIM(ENTRY(1, pcData, " ")) NO-ERROR.
    IF NOT AVAILABLE ttReg THEN
        iVal = INTEGER(TRIM(ENTRY(1, pcData, " "))).
    ELSE 
        iVal = ttReg.val.
    
    IF iVal <> 0 THEN
        iPointer = iPointer + INTEGER(TRIM(ENTRY(2, pcData, " "))).
    ELSE 
        iPointer = iPointer + 1.
END.

PROCEDURE instr-inc:
    DEFINE INPUT  PARAMETER pcData AS CHARACTER   NO-UNDO.

    FIND FIRST ttReg WHERE ttReg.reg = pcData NO-ERROR.
    ttReg.val = ttReg.val + 1.
END.

PROCEDURE instr-dec:
    DEFINE INPUT  PARAMETER pcData AS CHARACTER   NO-UNDO.

    FIND FIRST ttReg WHERE ttReg.reg = pcData NO-ERROR.
    ttReg.val = ttReg.val - 1.

END.


