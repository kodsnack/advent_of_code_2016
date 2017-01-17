<?php

class ScrambledLetters
{

    const LEFT = 'L';
    const RIGHT = 'R';
    const SWITCH = [1,1,6,2,7,3,0,4];

    private $string;

    public function __construct($string)
    {
        $this->string = $string;
    }

    public function swapPosition($posA, $posB)
    {
        $tmpChar = $this->string[$posB];
        $this->string[$posB] = $this->string[$posA];
        $this->string[$posA] = $tmpChar;
    }

    public function swapLetter($charA, $charB)
    {
        $tmpString = str_replace($charA, '*', $this->string);
        $tmpString = str_replace($charB, $charA, $tmpString);
        $this->string = str_replace('*', $charB, $tmpString);
    }

    public function reverse($position, $through)
    {
        $tmp = substr($this->string, $position, $through - $position + 1);
        $reverse = strrev($tmp);
        $this->string = str_replace($tmp, $reverse, $this->string);
    }

    public function rotate($direction, $steps)
    {
        $steps = $steps % strlen($this->string);
        if ($direction == $this::RIGHT) {
            $steps = strlen($this->string) - $steps;
        }
        $this->string = substr($this->string, $steps) . substr($this->string, 0, $steps);
    }

    public function move($posA, $posB)
    {
        $tmpChar = $this->string[$posA];
        $leftString = ($posA == 0) ? '' : substr($this->string, 0, $posA);
        $rightString = substr($this->string, $posA + 1);
        $tmpString = $leftString . $rightString;
        $leftString = ($posB == 0) ? '' : substr($tmpString, 0, $posB);
        $rightString = ($posB == strlen($tmpString)) ? '' : substr($tmpString, $posB);
        $this->string = $leftString . $tmpChar . $rightString;
    }

    public function rotateBased($char, $isReverse = false)
    {
        $steps = strpos($this->string, $char) + 1;
        $direction = 'R';
        $bonus = 0;
        if ($isReverse) {
            $steps = self::SWITCH[$steps-1];
            $direction = 'L';
        } elseif ($steps > 4) {
            $bonus = 1;
        }
        $this->rotate($direction, ($steps + $bonus) % strlen($this->string));
    }

    public function getString()
    {
        return $this->string;
    }
}