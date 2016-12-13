<?php

spl_autoload_register(function ($class) {
    include "$class.php";
});

//$fileInput = <<< STRING
//rect 3x2
//rotate column x=1 by 1
//rotate row y=0 by 4
//rotate column x=1 by 1
//STRING;
//$dispaySizeX = 7;
//$dispaySizeY = 3;

$fileInput = file_get_contents('input');
$dispaySizeX = 50;
$dispaySizeY = 6;

$lines = explode(PHP_EOL, $fileInput);
$screen = new TinyLCD($dispaySizeX, $dispaySizeY);
foreach ($lines as $line) {
    if (strpos($line, 'rect') === false) {
        preg_match('/rotate (.+?) [xy]=(\d+) by (\d+)/', $line, $matches);
        $size = $matches[1] == 'row' ? $screen::ROW : $screen::COLUMN;
        $screen->rotate($size, $matches[2], $matches[3]);
    } else {
        preg_match('/rect (\d+)x(\d+)/', $line, $matches);
        $screen->writeRect($matches[1], $matches[2]);
    }
}

echo PHP_EOL, $screen->countScreenLit(), PHP_EOL, PHP_EOL;
$screen->printScreen();
