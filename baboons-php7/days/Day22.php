<?php
declare(strict_types=1);

class Day22 {
    use DayTrait;

    public function execute()
    {
        $input = $this->getFile(FILE_IGNORE_NEW_LINES);

        $nodes = [];
        $empty = [];
        $max = 0;
        $viable = 0;

        foreach($input as $row) {
            if (preg_match('#x(?<x>\d+)-y(?<y>\d+)\s+(?<s>\d+)T\s+(?<u>\d+)T\s+(?<a>\d+)T\s+(?<p>\d+)%#', $row, $match)) {
                $match = array_diff_key($match, range(1,10));
                $nodes[] = $match;

                $max = max($match['x'], $max);

                if ($match['u'] == 0) $empty = $match;
            }
        }

        foreach ($nodes as $a) {
            foreach ($nodes as $b) {
                if ($a['x'] == $b['x'] && $a['y'] == $b['y']) continue;
                if ($a['a'] >= $b['u'] && $b['u'] > 0) $viable += 1;
            }
        }

        $this->setResult1((string) $viable)
             ->setResult2((string) ($empty['x'] + $empty['y'] + $max + ($max - 1) * 5));

    }

}

