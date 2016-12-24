<?php
declare(strict_types = 1);

class Day24
{
    use DayTrait;

    private $grid = [];

    private $locations = [];

    public function execute()
    {
        $this->setResult1((string) $this->solve(0))
             ->setResult2((string) $this->solve(1));

    }

    private function solve(int $mode = 0): int
    {
        $this->loadGrid();
        $this->loadLocations();

        $distances = $this->getDistances();
        $best = -1;
        foreach ($this->getPaths() as $path) {
            $len = 0;
            if ($mode === 1) $path .= '0';
            for ($i = 0; $i < strlen($path) - 1; $i++) {
                $len += $distances[$path[$i]][$path[$i + 1]];
            }
            if ($best == -1 || $len < $best) $best = $len;
        }

        return $best;
    }

    private function loadGrid()
    {
        if(count($this->grid) == 0) {
            $this->grid = $this->getFile(FILE_IGNORE_NEW_LINES);
        }
    }

    private function loadLocations()
    {
        if(count($this->locations) > 0 ) return false;

        $grid = $this->grid;

        $locations = [];
        for ($y = 0; $y < count($grid); $y++) {
            for ($x = 0; $x < strlen($grid[0]); $x++) {
                $f = $grid[$y][$x];
                if (is_numeric($f)) $locations[$f] = [$x, $y];
            }
        }

        $this->locations = $locations;
    }

    private function getPaths(): array
    {
        $paths = [];

        $keys = array_keys($this->locations);
        unset($keys[array_search(0, $keys)]);
        $this->setPathCombinations('0', implode('', $keys), $paths);

        return $paths;
    }

    private function setPathCombinations(string $id, string $locations, array &$combinations)
    {
        if (strlen($locations) == 0) $combinations[] = $id;
        for ($i = 0; $i < strlen($locations); $i++) {
            $this->setPathCombinations(
                $id . $locations[$i],
                substr($locations, 0, $i) . substr($locations, $i + 1),
                $combinations
            );
        }
    }

    private function getDistances()
    {
        $distances = [];
        foreach (array_keys($this->locations) as $num) {
            $this->nDistances($this->grid, $num, $this->locations, $distances, 0);
        }
        return $distances;
    }

    private function nField($field)
    {
        $next = [];
        for ($y = 0; $y < count($field); $y++) {
            $next[$y] = $field[$y];
        }
        return $next;
    }

    private function nDistances($field, $num, $locations, &$distances, $steps)
    {
        $next = $this->nField($field);
        $done = true;
        for ($y = 0; $y < count($field); $y++) {
            for ($x = 0; $x < strlen($field[0]); $x++) {
                if (is_numeric($field[$y][$x]) && $field[$y][$x] == $num) {
                    foreach ($locations as $n => $p) {
                        if ($p == [$x, $y]) {
                            if (!isset($distances[$num])) {
                                $distances[$num] = [];
                            }
                            $distances[$num][$n] = $steps;
                        }
                    }
                    $done = false;
                    $next[$y][$x] = '#';
                    if ($y - 1 >= 0 && $next[$y - 1][$x] != '#') {
                        $next[$y - 1][$x] = $num;
                    }
                    if ($y + 1 < count($next) && $next[$y + 1][$x] != '#') {
                        $next[$y + 1][$x] = $num;
                    }
                    if ($x - 1 >= 0 && $next[$y][$x - 1] != '#') {
                        $next[$y][$x - 1] = $num;
                    }
                    if ($x + 1 < strlen($next[$y]) && $next[$y][$x + 1] != '#') {
                        $next[$y][$x + 1] = $num;
                    }
                }
            }
        }
        if (!$done) $this->nDistances($next, $num, $locations, $distances, $steps + 1);
    }

}