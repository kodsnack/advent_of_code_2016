<?php

$input = 'reyedfim';

function decodeDoorId($input, $byPosition=false) {
    $i=0;
    $password = [];

    while(count($password) < 8) {

        $hash = md5($input . $i);

        if(substr($hash,0, 5) !== '00000') {
            $i++;
            continue;
        }

        if($byPosition) {
            $position = substr($hash, 5,1);
            
            if(!isset($password[$position]) && is_numeric($position) && $position < 8) {
                $password[$position] = substr($hash, 6,1);
            }
            
        } else {
            $password[] = substr($hash, 5,1);
        }

        $i++;
    }

    ksort($password);
    
    return implode("", $password);
}

echo "Part 1: " .  decodeDoorId($input) . PHP_EOL;
echo "Part 2: " .  decodeDoorId($input, true) . PHP_EOL;


