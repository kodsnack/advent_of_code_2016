<?php

//$fileInput = <<< STRING
//value 5 goes to bot 2
//bot 2 gives low to bot 1 and high to bot 0
//value 3 goes to bot 1
//bot 1 gives low to output 1 and high to bot 0
//bot 0 gives low to output 2 and high to output 0
//value 2 goes to bot 2
//STRING;

$fileInput = file_get_contents('input');
$lines = explode(PHP_EOL, $fileInput);

$bots = [];
$gives = [];
foreach ($lines as $line) {
    if (strpos($line, 'value') !== false) {
        preg_match('/^value (\d+) goes to bot (\d+)$/', $line, $matches);
        list(, $chip, $bot) = $matches;
        $bots[$bot][] = $chip;
    } else {
        preg_match('/^bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)$/', $line, $matches);
        list(, $bot, $binsLow, $low, $binsHigh, $high) = $matches;
        $gives[$bot][0] = [$binsLow, $low];
        $gives[$bot][1] = [$binsHigh, $high];
    }
}

list($startBot) = array_keys(array_filter(
    $bots,
    function ($bot) {
        return count($bot) == 2;
    }
));

$bots = comparing($startBot, $bots, $gives);

function comparing($idx, $bots, $gives)
{
    if (!isset($bots[$idx]) || count($bots[$idx]) != 2 || empty($bots[$idx][0]) || empty($bots[$idx][1])) {
        return $bots;
    }
    sort($bots[$idx]);
    $bot = $bots[$idx];
    if ($bot[0] == 17 && $bot[1] == 61) {
        echo "*** $idx ***", PHP_EOL;
    }

    list($binLow, $chipLow) = $gives[$idx][0];
    if ($binLow == 'bot') {
        $bots[$chipLow][] = $bot[0];
    } else {
        $bots['output'][$chipLow][] = $bot[0];
    }
    $bots[$idx][0] = null;

    list($binHigh, $chipHigh) = $gives[$idx][1];
    if ($binHigh == 'bot') {
        $bots[$chipHigh][] = $bot[1];
    } else {
        $bots['output'][$chipHigh][] = $bot[1];
    }
    $bots[$idx][1] = null;

    if ($binLow == 'bot') {
        $bots = comparing($chipLow, $bots, $gives);
    }
    if ($binHigh == 'bot') {
        $bots = comparing($chipHigh, $bots, $gives);
    }

    return $bots;
}

$sum = array_sum($bots['output'][0]) * array_sum($bots['output'][1]) * array_sum($bots['output'][2]);
echo $sum, PHP_EOL;