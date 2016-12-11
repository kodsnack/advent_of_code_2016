<?php

class Operation
{
    private $operation;

    public function __construct(string $operation)
    {
        $this->operation = $operation;
    }

    public function __toString() : string
    {
        return $this->operation;
    }

    /**
     * @param string $filename
     *
     * @return Operation[]
     */
    public static function createFromFile(string $filename) : array
    {
        $rows = explode(PHP_EOL, file_get_contents(dirname(__FILE__) . '/' . $filename));

        return array_map(function ($row) {
            return new self($row);
        }, $rows);
    }

    public function applyOnto(Screen $screen)
    {
        if ($this->isRectangle()) {
            list($width, $height) = $this->getRectangleSize();

            $screen->activateArea($width, $height);

            return;
        }

        if ($this->isRotateColumn()) {

            list($position, $length) = $this->getRotateValues();

            $screen->rotateColumn($position, $length);

            return;
        }

        if ($this->isRotateRow()) {

            list($position, $length) = $this->getRotateValues();

            $screen->rotateRow($position, $length);

            return;
        }

        throw new \Exception('Unknown operation ' . $this->operation);
    }

    private function isRectangle() : bool
    {
        return substr($this->operation, 0, 4) === 'rect';
    }

    private function getRectangleSize()
    {
        preg_match('/(\d+)x(\d+)/', $this->operation, $matches);

        $width  = intval($matches[1]);
        $height = intval($matches[2]);

        return [$width, $height];
    }

    private function isRotateColumn() : bool
    {
        return strpos($this->operation, 'rotate column') !== false;
    }

    private function isRotateRow() : bool
    {
        return strpos($this->operation, 'rotate row') !== false;
    }

    private function getRotateValues() : array
    {
        preg_match('/=(\d+) by (\d+)/', $this->operation, $matches);

        $position = intval($matches[1]);
        $length   = intval($matches[2]);

        return [$position, $length];
    }
}

class Screen
{
    /**
     * @var int
     */
    private $width;

    /**
     * @var int
     */
    private $height;

    /**
     * @var array
     */
    private $area = [];

    public function __construct(int $width, int $height)
    {
        $this->width  = $width;
        $this->height = $height;
        $this->area   = $this->createArea($width, $height);
    }

    private function createArea(int $width, int $height)
    {
        $area = [];

        for ($h = 0; $h < $height; $h++) {
            $area[] = array_map(function ($value) {
                return !!$value;
            }, explode(',', str_repeat(',', $width - 1)));
        }

        return $area;
    }

    public function getNumberOfPixelsLit()
    {
        $sum = 0;

        foreach ($this->area as $row) {
            foreach ($row as $column) {
                if ($column) {
                    $sum++;
                }
            }
        }

        return $sum;
    }

    public function activateArea(int $width, int $height)
    {
        for ($h = 0; $h < $height; $h++) {
            for ($w = 0; $w < $width; $w++) {
                $this->area[$h][$w] = true;
            }
        }
    }

    public function rotateColumn(int $position, int $length)
    {
        $area = $this->createArea($this->width, $this->height);

        for ($x = 0; $x < $this->width; $x++) {
            for ($y = 0; $y < $this->height; $y++) {

                if ($x === $position) {

                    $index = $y - $length;

                    while ($index < 0) {
                        $index += $this->height;
                    }

                    $area[$y][$x] = $this->area[$index][$x];

                } else {
                    $area[$y][$x] = $this->area[$y][$x];
                }
            }
        }

        $this->area = $area;
    }

    public function rotateRow(int $position, int $length)
    {
        $area = $this->createArea($this->width, $this->height);

        for ($x = 0; $x < $this->width; $x++) {
            for ($y = 0; $y < $this->height; $y++) {

                if ($y === $position) {

                    $index = $x - $length;

                    while ($index < 0) {
                        $index += $this->width;
                    }

                    $area[$y][$x] = $this->area[$y][$index];

                } else {
                    $area[$y][$x] = $this->area[$y][$x];
                }
            }
        }

        $this->area = $area;
    }

    public function draw()
    {
        for ($h = 0; $h < $this->height; $h++) {

            for ($w = 0; $w < $this->width; $w++) {
                echo $this->area[$h][$w] ? 'X' : ' ';
            }

            echo PHP_EOL;
        }
    }
}
