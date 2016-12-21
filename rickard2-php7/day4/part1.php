<?php

require 'lib.php';

$rooms = Room::createFromFile('input');

/** @var Room[] $realRooms */
$realRooms = array_filter($rooms, function (Room $room) {
    return $room->isReal();
});

$sum = 0;

foreach ($realRooms as $realRoom) {
    $sum += $realRoom->getSectorId();
}

printf('The sum of the sector IDs of the real rooms is: %d' . PHP_EOL, $sum);