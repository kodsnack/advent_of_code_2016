<?php

$commands = file('input');

$registers = [];
$registers['a'] = 12;
echo safe_cracking($commands, $registers), PHP_EOL;

function safe_cracking($commands, $registers)
{
    $idx = 0;
    $numCommands = sizeof($commands);
    while(true) {
        $matches = explode(' ', trim($commands[$idx]));
        @list($cmd, $register1, $register2) = $matches;
        switch($cmd) {
            case 'cpy':
                if (is_numeric($register1) && !is_numeric($register2)) {
                    $registers[$register2] = $register1;
                } else {
                    $registers[$register2] = $registers[$register1];
                }
                break;
            case 'inc':
                if (isset($registers[$register1])) {
                    $registers[$register1]++;
                }
                break;
            case 'dec':
                if (isset($registers[$register1])) {
                    $registers[$register1]--;
                }
                break;
            case 'jnz':
                if ((is_numeric($register1) && $register1 != 0) || (isset($registers[$register1]) && is_numeric($registers[$register1]) && $registers[$register1] != 0)) {
                    if (is_numeric($register2)) {
                        $counter = $register2;
                    } elseif (is_numeric($registers[$register2])) {
                        $counter = $registers[$register2];
                    } else {
                        break;
                    }
                    for ($i = 0; $i < abs($counter - 1); $i++) {
                        if ($counter > 0) {
                            $idx++;
                        } else {
                            $idx--;
                        }
                    }
                }
                break;
            case 'tgl':
                if ($registers[$register1] >= $numCommands) {
                    break;
                }
                @list($subcom, $subreg1, $subreg2) = explode(' ', trim($commands[$idx + $registers[$register1]]));
                if (!isset($subreg2)) {
                    $commands[$idx + $registers[$register1]] = ($subcom == 'inc' ? 'dec' : 'inc') . " $subreg1";
                } else {
                    $commands[$idx + $registers[$register1]] = ($subcom == 'jnz' ? 'cpy' : 'jnz') . " $subreg1 $subreg2";
                }
                break;
        }
        $idx++;
        if(!isset($commands[$idx])) {
            break;
        }
    }

    return $registers['a'];
}
