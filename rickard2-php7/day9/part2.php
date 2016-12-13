<?php

require 'lib.php';

$input = file_get_contents(dirname(__FILE__) . '/input');

$parser = new Parser2($input);

$pieces = $parser->getPieces();

$length = 0;

foreach ($pieces as $piece) {
    $length += $piece->getDecompressedLength();
}

printf('The decompressed length of the file is: %d' . PHP_EOL, $length);