<?php

require 'lib.php';

$rooms = Room::createFromFile('input');

/** @var Room[] $realRooms */
$realRooms = array_filter($rooms, function (Room $room) {
    return $room->isReal();
});

foreach ($realRooms as $room) {
    if ($room->getName() === 'northpole object storage') {
        printf('The sector ID of the room where North Pole objects are stored is: %d' . PHP_EOL, $room->getSectorId());
        exit;
    }
}