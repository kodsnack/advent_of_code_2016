<?php

function compute(array $instructions, array $registers) : array {
    for ($index = 0; $index < count($instructions); $index++) {

        $instruction = $instructions[$index];
        $instructionType = substr($instruction, 0, 3);
        $isCopy = $instructionType === 'cpy';
        $isJump = $instructionType === 'jnz';
        $isIncrease = $instructionType === 'inc';
        $isDecrease = $instructionType === 'dec';

        if ($isCopy) {
            $value = substr($instruction, 4);
            $value = substr($value, 0, (strlen($value) - 2)); 
            $register = substr($instruction, -1, 1);

            if (is_numeric($value)) {
                $registers[$register] = $value;
            } else {
                $registers[$register] = isset($registers[$value]) ? $registers[$value] : null;
            }
        }

        if ($isJump) {
            list($x, $y) = explode(' ', substr($instruction, 4));

            $shouldJump = is_numeric($x) && $x != 0 || isset($registers[$x]) && $registers[$x] != 0;

            if ($shouldJump) {
                $index += $y;

                // for loop adds one again so make sure to move one more step back
                $index--;
            }
        }

        if ($isIncrease) {
            $register = substr($instruction, 4);
            $registers[$register]++;
        }

        if ($isDecrease) {
            $register = substr($instruction, 4);
            $registers[$register]--;
        }
    }

    return $registers;
}
