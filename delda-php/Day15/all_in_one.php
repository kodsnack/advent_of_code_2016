<?php

$arrangements[] = 'Disc #1 has 5 positions; at time=0, it is at position 4.';
$arrangements[] = 'Disc #2 has 2 positions; at time=0, it is at position 1.';
$arrangements = file('input');

$arrangement = [];
foreach ($arrangements as $lineNumber => $arrangementLine) {
    preg_match('/^Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+).$/', $arrangementLine, $matches);
    list(, $disc, $step, $position) = $matches;
    $arrangement[$disc] = ['step' => $step, 'position' => $position];
}

echo pressTheButton($arrangement), PHP_EOL;

$arrangement[7] = ['step' => 11, 'position' => 0];
echo pressTheButton($arrangement), PHP_EOL;

function pressTheButton($arrangement)
{
    $time = -1;
    do {
        $time++;
        $getACapsule = true;
        foreach ($arrangement as $disc => $data) {
            if (($data['position'] + $time + $disc) % $data['step'] != 0) {
                $getACapsule = false;
            }
        }
    } while ($getACapsule === false);

    return $time;
}