<?php

function monorail_control_system($commands, $registers)
{
    while(true) {
        $matches = explode(' ', trim(current($commands)));
        @list($cmd, $register1, $register2) = $matches;
        switch($cmd) {
            case 'cpy':
                if (is_numeric($register1)) {
                    $registers[$register2] = $register1;
                } else {
                    $registers[$register2] = $registers[$register1];
                }
                break;
            case 'inc':
                $registers[$register1]++;
                break;
            case 'dec':
                $registers[$register1]--;
                break;
            case 'jnz':
                if ((is_numeric($register1) && $register1 != 0) || (isset($registers[$register1]) && $registers[$register1] != 0)) {
                    for ($i = 0; $i < abs($register2 - 1); $i++) {
                        if ($register2 > 0) {
                            next($commands);
                        } else {
                            prev($commands);
                        }
                    }
                }
                break;
        }
        if(!next($commands)) {
            break;
        }
    }

    return $registers['a'];
}