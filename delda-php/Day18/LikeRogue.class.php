<?php

class LikeRogue
{
    private $floor = [];
    private $numRows;
    private $numColumns = 0;

    public function findTraps($firstRow, $numRows)
    {
        $this->floor[] = $firstRow;
        $this->numRows = $numRows;
        $this->numColumns = strlen($firstRow);
        for ($x = 1; $x < $this->numRows; $x++) {
            for ($y = 0; $y < $this->numColumns; $y++) {
                $this->floor[$x][$y] = $this->isNewTrap($x, $y) ? '^' : '.';
            }
        }

        return $this->countSafeTiles();
    }

    private function isNewTrap($x, $y)
    {
        $left = ($y == 0) ? null : $this->floor[$x-1][$y-1];
        $center = $this->floor[$x-1][$y];
        $right = ($y == $this->numColumns-1) ? null : $this->floor[$x-1][$y+1];
        if (
            ($y == 0      && $center == '^' && $right == '^')               ||
            ($y == 0      && $center == '.' && $right == '^')               ||
            ($left == '^' && $center == '^' && $y == ($this->numColumns-1)) ||
            ($left == '^' && $center == '.' && $y == ($this->numColumns-1)) ||
            ($left == '^' && $center == '^' && $right == '.')               ||
            ($left == '.' && $center == '^' && $right == '^')               ||
            ($left == '^' && $center == '.' && $right == '.')               ||
            ($left == '.' && $center == '.' && $right == '^')
        ) {
            return true;
        }

        return false;
    }

    public function printFloor()
    {
        echo PHP_EOL;
        for ($x = 0; $x < $this->numRows; $x++) {
            for ($y = 0; $y < $this->numColumns; $y++) {
                echo $this->floor[$x][$y];
            }
            echo PHP_EOL;
        }
        echo PHP_EOL;
    }

    private function countSafeTiles()
    {
        $counter = 0;
        for ($x = 0; $x < $this->numRows; $x++) {
            for ($y = 0; $y < $this->numColumns; $y++) {
                if ($this->floor[$x][$y] == '.') {
                    $counter++;
                }
            }
        }

        return $counter;
    }
}