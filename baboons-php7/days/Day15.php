<?php
declare(strict_types=1);


class Day15 {
    use DayTrait;

    public function execute()
    {
        $discs = [];
        $extras = [11,0];

        foreach($this->getFile() as $line) {
            $line = explode(" ", $line);
            $discs[trim($line[1], "#")] = [$line[3], substr($line[11],0, strpos($line[11], '.'))];
        }

        $this->setResult1((string) $this->spin($discs));

        $discs[] = $extras;
        $this->setResult2((string) $this->spin($discs));

    }

    private function spin(array $discs): int
    {
        $time = 0;

        while(true) {
            $success = true;

            foreach($discs as $num => $disc) {
                list($has, $at) = $disc;
                if(($at + $num + $time) % $has > 0) $success = false;
            }

            if($success) break;

            $time += 1;
        }

        return $time;
    }
}

