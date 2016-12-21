<?php

class TinyLCD
{
    const ROW = 0;
    const COLUMN = 1;

    private $screen = [];
    private $screenWidth;
    private $screenHeight;

    function __construct($x, $y)
    {
        $this->screenWidth = $x;
        $this->screenHeight = $y;
        for ($i = 0; $i < $this->screenHeight; $i++) {
            for ($j = 0; $j < $this->screenWidth; $j++) {
                $this->screen[$i][$j] = false;
            }
        }
    }

    function writeRect($x, $y)
    {
        for ($i = 0; $i < $x; $i++) {
            for ($j = 0; $j < $y; $j++) {
                $this->screen[$j][$i] = true;
            }
        }
    }

    function rotate($size, $index, $step)
    {
        if ($size == self::ROW) {
            $tmp = [];
            for ($i = 0; $i < $this->screenWidth; $i++) {
                $tmp[($i + $step) % $this->screenWidth] = $this->screen[$index][$i];
            }
            $this->screen[$index] = $tmp;
        } else {
            $tmp = [];
            for ($i = 0; $i < $this->screenHeight; $i++) {
                $tmp[($i + $step) % $this->screenHeight] = $this->screen[$i][$index];
            }
            for ($i = 0; $i < $this->screenHeight; $i++) {
                $this->screen[$i][$index] = $tmp[$i];
            }
        }
    }

    function printScreen()
    {
        for ($x = 0; $x < $this->screenHeight; $x++) {
            for ($y = 0; $y < $this->screenWidth; $y++) {
                if ($this->screen[$x][$y] === true) {
                    echo '#';
                } else {
                    echo '.';
                }
            }
            echo PHP_EOL;
        }
    }

    function countScreenLit()
    {
        $count = 0;
        for ($x = 0; $x < $this->screenHeight; $x++) {
            for ($y = 0; $y < $this->screenWidth; $y++) {
                $count += ($this->screen[$x][$y] === true) ? 1 : 0;
            }
        }

        return $count;
    }
}
