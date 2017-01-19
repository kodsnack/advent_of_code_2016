<?php

class AirDuctSpelunking
{
    private $sizeX, $sizeY;
    private $map;

    public function __construct($map)
    {
        $this->map = $map;
        $this->sizeX = sizeof($map);
        $this->sizeY = sizeof($map[0]);
    }

    private function neighborhood($coord, $map)
    {
        list($x, $y) = $coord;
        $coordinates = [];
        if ($x > 0) {
            $coordinates[] = [$x - 1, $y];
        }
        if ($x < $this->sizeX) {
            $coordinates[] = [$x + 1, $y];
        }
        if ($y > 0) {
            $coordinates[] = [$x, $y - 1];
        }
        if ($y < $this->sizeY) {
            $coordinates[] = [$x, $y + 1];
        }

        $coordinates = array_filter(
            $coordinates,
            function($coord) use ($map) {
                if ($map[$coord[0]][$coord[1]] == '#' || $map[$coord[0]][$coord[1]] == '@') {
                    return false;
                }
                return true;
            }
        );

        return $coordinates;
    }

    public function shortestRoute($withReturn = false)
    {
        $distances = [];
        $points = $this->pointsOfInterest();
        foreach ($points as $point => $coord) {
            $distances[$point] = $this->BFS($coord);
        }

        $set = array_keys($points);
        $size = count($set) - 1;
        $perm = range(0, $size);
        $j = 0;
        do {
            if ($perm[0] == 0) {
                foreach ($perm as $i) {
                    $perms[$j][] = $set[$i];
                }
            }
            $j++;
        } while ($perm = $this->getPermutations($perm, $size));

        $minSteps = array_reduce(
            array_keys($perms),
            function ($minSteps, $key) use ($perms, $distances, $withReturn) {
                $steps = 0;
                $prevKey = 0;
                foreach ($perms[$key] as $value) {
                    if ($value != $prevKey) {
                        $steps += $distances[$prevKey][$value];
                        $prevKey = $value;
                    }
                }
                if ($withReturn) {
                    $steps += $distances[$prevKey][0];
                }
                if ($minSteps > $steps) {
                    $minSteps = $steps;
                }
                return $minSteps;
            },
            PHP_INT_MAX
        );

        return $minSteps;
    }

    private function BFS($coord)
    {
        $pointsDistance = [];
        $map = $this->map;
        $steps = 0;
        $queue = new SplQueue();
        $queue->enqueue(['coord' => $coord, 'steps' => $steps]);
        while (true) {
            if ($queue->count() > 0) {
                list($coord, $steps) = array_values($queue->dequeue());
            } else {
                break;
            }
            if ($map[$coord[0]][$coord[1]] == '@') {
                continue;
            }
            if (is_numeric($map[$coord[0]][$coord[1]])) {
                $pointsDistance[$map[$coord[0]][$coord[1]]] = $steps;
            }
            $map[$coord[0]][$coord[1]] = '@';
            foreach ($this->neighborhood($coord, $map) as $neigh) {
                $queue->enqueue(['coord' => $neigh, 'steps' => $steps + 1]);
            }
        }

        return $pointsDistance;
    }

    private function pointsOfInterest()
    {
        $coord = [];
        for ($x = 0; $x < $this->sizeX; $x++) {
            for ($y = 0; $y < $this->sizeY; $y++) {
                if (is_numeric($this->map[$x][$y])) {
                    $coord[$this->map[$x][$y]] = [$x, $y];
                }
            }
        }

        return $coord;
    }

    private function getPermutations($p, $size)
    {
        for ($i = $size - 1; $p[$i] >= $p[$i + 1]; --$i) {
        }
        if ($i == -1) {
            return false;
        }
        for ($j = $size; $p[$j] <= $p[$i]; --$j) {
        }
        $tmp = $p[$i];
        $p[$i] = $p[$j];
        $p[$j] = $tmp;
        for (++$i, $j = $size; $i < $j; ++$i, --$j) {
            $tmp = $p[$i];
            $p[$i] = $p[$j];
            $p[$j] = $tmp;
        }
        return $p;
    }

    public function printMap($map = null)
    {
        echo chr(27).chr(91).'H'.chr(27).chr(91).'J';
        if (!isset($map)) {
            $map = $this->map;
        }
        for ($x = 0; $x < $this->sizeX-20; $x++) {
            for ($y = 0; $y < $this->sizeY-10; $y++) {
                echo $map[$x][$y];
            }
            echo PHP_EOL;
        }
    }
}