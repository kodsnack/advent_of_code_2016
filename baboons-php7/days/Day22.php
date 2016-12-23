<?php
declare(strict_types=1);

define('NODE_AVAILABLE', 1);
define('NODE_EMPTY',     0);
define('NODE_FULL',      -1);

class Day22 {
    use DayTrait;

    public function execute()
    {
        $input = $this->getFile(FILE_IGNORE_NEW_LINES);

        $nodes = [];
        $grid = [];

        foreach($input as $row) {
            if (preg_match('#x(?<x>\d+)-y(?<y>\d+)\s+(?<s>\d+)T\s+(?<u>\d+)T\s+(?<a>\d+)T\s+(?<p>\d+)%#', $row, $match)) {
                $match = array_diff_key($match, range(1,10));
                $nodes[] = $match;

                if (!isset($grid[$match['y']])) $grid[$match['y']] = [];

                if ($match['u'] == 0)
                    $grid[$match['y']][$match['x']] = NODE_EMPTY;
                elseif ($match['p'] > 90)
                    $grid[$match['y']][$match['x']] = NODE_FULL;
                else
                    $grid[$match['y']][$match['x']] = NODE_AVAILABLE;

            }
        }

        $this->setResult1((string) $this->viables($nodes))
             ->setResult2((string) $this->move($grid));

    }

    private function viables(array $nodes): int
    {
        $viable = 0;
        
        foreach ($nodes as $a) {
            foreach ($nodes as $b) {
                if ($a['x'] == $b['x'] && $a['y'] == $b['y']) continue;
                if ($a['a'] >= $b['u'] && $b['u'] > 0) $viable += 1;
            }
        }
        
        return $viable;
    }
    
    private function move(array $grid): int
    {

        function step(array $field): int {
            if ($field[0][count($field[0])-2] === NODE_EMPTY) return 0;

            $next = array();

            for ($y=0;$y<count($field);$y++) {
                $next[$y] = $field[$y];
            }

            for ($y=0;$y<count($field);$y++) {
                for ($x=0;$x<count($field[$y]);$x++) {
                    if ($field[$y][$x] === NODE_EMPTY) {
                        $next[$y][$x] = NODE_EMPTY;

                        if ($y-1>=0 && $next[$y-1][$x] === NODE_AVAILABLE)
                            $next[$y-1][$x] = NODE_EMPTY;

                        if ($y+1<count($next) && $next[$y+1][$x] === NODE_AVAILABLE)
                            $next[$y+1][$x] = NODE_EMPTY;

                        if ($x-1>=0 && $next[$y][$x-1] === NODE_AVAILABLE)
                            $next[$y][$x-1] = NODE_EMPTY;

                        if ($x+1<count($next[$y]) && $next[$y][$x+1] === NODE_AVAILABLE)
                            $next[$y][$x+1] = NODE_EMPTY;
                    }
                }
            }
            return step($next)+1;
        }

        return step($grid)+5*(count($grid[0])-2)+1;
    }
    
}

