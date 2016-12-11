<?php
declare(strict_types=1);


class Day10 {
    use DayTrait;

    public function execute()
    {
        $bots = [];
        $givings = [];
        $outputs = [];

        foreach($this->getFile() as $row) {
            $row = explode(" ", trim($row));

            if($row[0] == "bot") {
                $giver = $row[1];
                array_push($givings, [$giver, $row[6], $row[11], $row[5], $row[10]]);
            } elseif($row[0] == "value") {
                if(!isset($bots[$row[5]])) $bots[$row[5]] = [];
                array_push($bots[$row[5]], $row[1]);
            } else {
                throw new Exception('Invalid instruction');
            }

        }

        while(count($givings) > 0) {
            foreach($givings as $i => $give) {
                list($giver, $low, $high, $lowType, $highType) = $give;

                if(!isset($bots[$giver]) || count($bots[$giver]) < 2) {
                    continue;
                }

                $min = min($bots[$giver]);
                $max = max($bots[$giver]);

                if($min == 17 && $max == 61) {
                    $this->setResult1((string) $giver);
                }

                $bots[$giver] = [];

                if($lowType === 'bot') {
                    if(!isset($bots[$low])) $bots[$low] = [];
                    array_push($bots[$low], $min);
                } else {
                    if(!isset($outputs[$low])) $outputs[$low] = [];
                    array_push($outputs[$low], $min);
                }

                if($highType === 'bot') {
                    if(!isset($bots[$high])) $bots[$high] = [];
                    array_push($bots[$high], $max);
                } else {
                    if(!isset($outputs[$high])) $outputs[$high] = [];
                    array_push($outputs[$high], $max);
                }

                unset($givings[$i]);

                if((isset($bots[$low]) && count($bots[$low]) == 2) || (isset($bots[$high]) && count($bots[$high]) == 2)) {
                    reset($givings);
                    continue;
                }

            }
        }

        $this->setResult2((string) (array_sum($outputs[0]) * array_sum($outputs[1]) * array_sum($outputs[2])));
    }
}
