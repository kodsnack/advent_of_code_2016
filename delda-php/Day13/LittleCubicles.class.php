<?php

class LittleCubicles
{
    private $officeDesignersFavoriteNumber;
    private $map;

    public function __construct($officeDesignersFavoriteNumber)
    {
        $this->officeDesignersFavoriteNumber = $officeDesignersFavoriteNumber;
    }

    private function printLocation($x, $y)
    {
        if (($x == 31 && $y == 39) || ($x == 1 && $y == 1)) {
            return '@';
        } elseif (isset($this->map[$x][$y])) {
            return "o";
        } else {
            return $this->isWall($x, $y) ? '#' : '.';
        }
    }

    public function printMap()
    {
        $map = '';
        for ($y = 0; $y < 50; $y++) {
            for ($x = 0; $x < 50; $x++) {
                $map .= $this->printLocation($x, $y);
            }
            $map .= PHP_EOL;
        }
        return $map;
    }

    private function isWall($x, $y)
    {
        $coordinateNumber = ($x * $x) + (3 * $x) + (2 * $x * $y) + $y + ($y * $y) + $this->officeDesignersFavoriteNumber;
        $bin = decbin($coordinateNumber);
        return substr_count($bin, '1') % 2;
    }

    public function BFS($coordinates, $maxSteps = null)
    {
        $queue = new SplQueue();
        list($x, $y) = $coordinates;
        $queue->enqueue([$x, $y, 0]);
        $this->map[$x][$y]['visited'] = true;
        while ($queue->count() > 0) {
            list($x, $y, $step) = $queue->dequeue();

            if(isset($maxSteps) && $step > $maxSteps) {
                $count = 0;
                foreach($this->map as $x => $xValue) {
                    foreach ($xValue as $y => $yValue) {
                        if (isset($this->map[$x][$y]['marked'])) {
                            $count++;
                        }
                    }
                }
                return $count;
            }

            if (($x == 31) && ($y == 39)) {
                return $step;
            }

            if (!isset($this->map[$x][$y]['marked'])) {
                $this->map[$x][$y]['marked'] = true;
                foreach ($this->neigborhood($x, $y) as $coordinates) {
                    list($x, $y) = $coordinates;
                    if (!isset($this->map[$x][$y]) && !$this->isWall($x, $y)) {
                        $this->map[$x][$y]['visited'] = true;
//                        echo "$x, $y", PHP_EOL;
                        $queue->enqueue([$x, $y, $step+1]);
                    }
                }
            }
        }
        return false;
    }

    private function neigborhood($x, $y)
    {
        if ($x > 0) {
            $coordinates[] = [$x-1, $y];
        }
        if ($y > 0) {
            $coordinates[] = [$x, $y-1];
        }
        $coordinates[] = [$x, $y+1];
        $coordinates[] = [$x+1, $y];

        return $coordinates;
    }

    public function countLocations()
    {
        return count($this->map, COUNT_RECURSIVE);
    }
}