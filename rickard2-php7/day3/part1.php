<?php

require 'lib.php';

$triangles = Triangle::createFromRowsInFile('input');

$validTriangles = array_filter($triangles, function (Triangle $triangle) {
    return $triangle->isValid();
});

printf('Only %d out of the total %d triangles are possible' . PHP_EOL, count($validTriangles), count($triangles));