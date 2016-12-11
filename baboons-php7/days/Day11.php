<?php
declare(strict_types=1);

class Day11 {
    use DayTrait;

    public function execute()
    {
        $matrix = [];

        foreach($this->getFile() as $i => $line) {
            $items = explode(' a ', substr($line, strpos($line,'contains')));
            unset($items[0]);

            $matrix[] = count($items);
        }

        $this->setResult1((string) $this->sum($matrix));

        $matrix[0] += 4;

        $this->setResult2((string) $this->sum($matrix));
    }

    private function sum(array $matrix): int {
        $sum = 0;

        for($i=0;$i<4;$i++) {
            $partial = array_slice($matrix, 0, $i);
            $sum += 2 * array_sum($partial) - 3;
        }

        return $sum + 3;
    }

}
