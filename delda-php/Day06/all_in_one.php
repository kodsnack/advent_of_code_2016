<?php
$fileInput = <<<STRING
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
STRING;

$fileInput = file_get_contents('input');
$lines = explode(PHP_EOL, $fileInput);

$count=0;
$map = [];
foreach ($lines as $line) {
    $sizeOfLine = strlen($line);
    for ($i=0; $i<$sizeOfLine; $i++) {
        $char = $line[$i];
        $map[$i][$char] = isset($map[$i][$char]) ? $map[$i][$char]+1 : 1;
    }
}

$firstPartResult = $secondPartResult = '';
for ($i=0; $i<$sizeOfLine; $i++) {
    $key = array_search(max($map[$i]), $map[$i]);
    $firstPartResult .= $key;
    $key = array_search(min($map[$i]), $map[$i]);
    $secondPartResult .= $key;
}

echo "First part: $firstPartResult", PHP_EOL;
echo "Second part: $secondPartResult", PHP_EOL;
