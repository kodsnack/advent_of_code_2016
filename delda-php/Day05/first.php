<?php
//$fileInput = 'abc';
$fileInput = file_get_contents('input');

$index = $counter = 0;
$password = '';
while ($index < 8) {
    $hash = md5("$fileInput$counter");
    if (strpos($hash, '00000') === 0) {
        echo "$fileInput$counter - $hash", PHP_EOL;
        $index++;
        $password .= substr($hash, 5, 1);
    }
    $counter++;
}

echo $password, PHP_EOL;