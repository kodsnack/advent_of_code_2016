<?php

class Triangle
{
    /**
     * @var int
     */
    private $sideA;

    /**
     * @var int
     */
    private $sideB;

    /**
     * @var int
     */
    private $sideC;

    public function __construct(int $sideA, int $sideB, int $sideC)
    {
        $this->sideA = $sideA;
        $this->sideB = $sideB;
        $this->sideC = $sideC;
    }

    public function isValid() : bool
    {
        return ($this->sideA + $this->sideB > $this->sideC) &&
        ($this->sideA + $this->sideC > $this->sideB) &&
        ($this->sideB + $this->sideC > $this->sideA);
    }


    public static function createFromColumnsInFile(string $filename) : array
    {
        $input = file_get_contents(dirname(__FILE__) . '/' . $filename);
        $rows  = array_map(function ($row) {

            return array_values(array_filter(explode(' ', $row)));

        }, explode(PHP_EOL, $input));

        $max       = count($rows) - 2;
        $triangles = [];

        for ($i = 0; $i < $max; $i += 3) {
            $triangles[] = new self($rows[$i][0], $rows[$i + 1][0], $rows[$i + 2][0]);
            $triangles[] = new self($rows[$i][1], $rows[$i + 1][1], $rows[$i + 2][1]);
            $triangles[] = new self($rows[$i][2], $rows[$i + 1][2], $rows[$i + 2][2]);
        }

        return $triangles;
    }

    public static function createFromRowsInFile(string $filename) : array
    {
        $input = file_get_contents(dirname(__FILE__) . '/' . $filename);
        $rows  = array_map(function ($row) {

            return array_values(array_filter(explode(' ', $row)));

        }, explode(PHP_EOL, $input));

        return array_map(function ($numbers) {
            return Triangle::createFromArray($numbers);
        }, $rows);
    }

    public static function createFromArray(array $numbers) : Triangle
    {
        return new self($numbers[0], $numbers[1], $numbers[2]);
    }
}