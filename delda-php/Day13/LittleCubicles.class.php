<?php

class LittleCubicles
{
    public function printMap()
    {
        for ($i = 0; $i < 40; $i++) {
            for ($y = 0; $y < 40; $y++) {
                echo ($this->isOpenSpace($i, $y, 1364)) ? '.' : '#', PHP_EOL;
            }
        }
    }

    private function isOpenSpace($x, $y, $officeDesignersFavoriteNumber)
    {
        $coordinateNumber = $x * $x + 3 * $x + 2 * $x * $y + $y + $y * $y + $officeDesignersFavoriteNumber;
        $bin = decbin($coordinateNumber);
        return (substr_count($bin, '1') % 2) ? true : false;
    }
}