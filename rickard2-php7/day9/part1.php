<?php

require 'lib.php';

$input = file_get_contents(dirname(__FILE__) . '/input');

$parser = new Parser1($input);

$pieces = $parser->getPieces();

$text = join('', array_map(function (Piece $piece) {
    return $piece->decompress();
}, $pieces));

printf('The decompressed length of the file is: %d' . PHP_EOL, strlen($text));