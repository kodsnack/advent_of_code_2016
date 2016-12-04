<?php

$input = array_map("rtrim", file(__DIR__  . '/input/day3.txt'));
$validTriangles1 = 0;
$validTriangles2 = 0;

foreach($input as $row) {

    $triangle = array_map("trim", str_split($row, 5));

    if(validateTriangle($triangle)) {
        $validTriangles1 += 1;
    }
}

for($i=0;$i<count($input);$i+=3) {

    for($j=0;$j<3;$j++) {
        $triangle = [
            str_split($input[$i],   5)[$j],
            str_split($input[$i+1], 5)[$j],
            str_split($input[$i+2], 5)[$j]
        ];

        if(validateTriangle($triangle)) {
            $validTriangles2 += 1;
        }

    }
}

echo "Part 1: " . $validTriangles1 . PHP_EOL;
echo "Part 2: " . $validTriangles2 . PHP_EOL;

/**
 * Validate a triangle
 * @param array $triangle
 * @return bool
 */
function validateTriangle(array $triangle) {
    sort($triangle);
    return $triangle[0] + $triangle[1] > $triangle[2];
}