<?php
declare(strict_types=1);

class Day19 {
    use DayTrait;

    public function execute()
    {
        $players = (int) $this->getInput();
        $this->setResult1((string) $this->next($players))
             ->setResult2((string) $this->across($players));
    }

    private function next(int $players): int
    {
        $i = $this->calc($players, 2);
        $current = 2 ** ($i-1);
        return  2 * ($players-$current) + 1;
    }

    private function across(int $players): int
    {
        $i = $this->calc($players, 3);
        $current = 3 ** ($i-1) + 1;
        $increase = 3 ** $i * 2 / 3;

        return max(2 * ($players - $increase),0 ) + min($players, $increase) - $current + 1;
    }

    private function calc(int $players, int $mode): int
    {
        $i = 1;

        while(($mode ** $i) <= $players) {
            $i += 1;
        }

        return $i;
    }


}

