<?php
declare(strict_types=1);

define('TRAP', '^');
define('SAFE', '.');

class Day18 {
    use DayTrait;

    public function execute()
    {
        $this->setResult1((string) $this->solve(40))
             ->setResult2((string) $this->solve(400000));
    }

    private function solve(int $size): int
    {
        $input = $this->getFile();

        while(count($input) < $size) {
            end($input);
            $tiles = current($input);
            $length = strlen($tiles)-1;

            $addRow = '';

            for($i=0; $i<=$length; $i++) {
                $left   = $i == 0       ? SAFE : $tiles[$i-1];
                $center = $tiles[$i];
                $right  = $i == $length ? SAFE : $tiles[$i+1];

                $addRow .=  (($left == $center) && ($center == $right)
                    || ($left == $right) && ($center !== $left)) ? SAFE : TRAP;
            }

            $input[] = $addRow;
        }

        return substr_count(implode("\n", $input), SAFE);
    }
}

