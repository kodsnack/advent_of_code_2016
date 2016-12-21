<?php
declare(strict_types=1);

define('SCRAMBLE',      1);
define('UNSCRAMBLE',    2);
define('BACKWARD',      [1,1,6,2,7,3,0,4]);

class Day21 {
    use DayTrait;

    public function execute()
    {
        $this->setResult1($this->scramble("abcdefgh", SCRAMBLE))
             ->setResult2($this->scramble("fbgdceah", UNSCRAMBLE));
    }

    private function scramble($password, $mode)
    {
        $input = $this->getFile();

        if($mode === UNSCRAMBLE) {
            $input = array_reverse($input);
        }

        foreach($input as $i => $row) {
            $instructions = explode(" ", trim($row));

            switch($instructions[0]) {
                case "swap":
                    if ($instructions[1] == 'position') {
                        $password = $this->swap($password, $instructions[2], $instructions[5]);
                    } elseif ($instructions[1] == 'letter') {
                        $password = $this->swap($password, strpos($password, $instructions[2]), strpos($password, $instructions[5]));
                    }
                    break;

                case "reverse":
                    $password = $this->rev($password, (int) $instructions[2], (int) $instructions[4]);
                    break;

                case "rotate":

                    if($instructions[1] == "based") {
                        $steps = strpos($password, $instructions[6]) + 1;
                        $direction = 'right';

                        if($mode == UNSCRAMBLE) $steps = BACKWARD[$steps-1];
                        else if ($steps > 4) $steps += 1;

                    } else {
                        $direction = $instructions[1];
                        $steps = $instructions[2];
                    }

                    if($mode == UNSCRAMBLE) {
                        if($direction == "right")     $direction = "left";
                        elseif ($direction == "left") $direction = "right";
                    }

                    $password = $this->rotate($password, $direction, $steps);

                    break;

                case "move":
                    $x = $mode == SCRAMBLE ? $instructions[2] : $instructions[5];
                    $y = $mode == SCRAMBLE ? $instructions[5] : $instructions[2];
                    $password = $this->move($password, (int) $x, (int) $y);
                    break;
            }
        }

        return $password;
    }

    private function rotate($string, $direction, $shift)
    {
        $result = str_split($string, 1);

        if($direction == "right") {
            $shift = $shift * -1;
        }

        $shift %= count($result);
        if($shift < 0) $shift += count($result);
        return implode("", array_merge(array_slice($result, $shift, NULL, true), array_slice($result, 0, $shift, true)));

    }

    private function move($string, $x, $y)
    {
        $string = str_split($string, 1);
        $result = $string;
        unset($result[$x]);

        array_splice($result, $y, 0, $string[$x]);

        return implode("", $result);
    }

    private function swap($string, $x, $y)
    {
        $result = $string;

        $result[$x] = $string[$y];
        $result[$y] = $string[$x];

        return $result;
    }

    private function rev($string, $from, $to)
    {
        return substr($string,0, $from) . strrev(substr($string, $from, $to - $from + 1)) . substr($string,$to +1);
    }

}

