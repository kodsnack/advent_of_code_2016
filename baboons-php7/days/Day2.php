<?php
declare(strict_types=1);

define('KEYPAD_UP',     'U');
define('KEYPAD_DOWN',   'D');
define('KEYPAD_RIGHT',  'R');
define('KEYPAD_LEFT',   'L');

class Day2 {
    use DayTrait;

    public function execute()
    {
        $keypad1 = [
            [1,2,3],
            [4,5,6],
            [7,8,9]
        ];

        $keypad2 = [
            [NULL,  NULL,    1,      NULL,    NULL],
            [NULL,   2,      3,       4,      NULL],
            [ 5,     6,      7,       8,        9 ],
            [NULL,  'A',    'B',     'C',     NULL],
            [NULL,  NULL,   'D',     NULL,    NULL]
        ];

        $this->setResult1($this->getKeyCode($keypad1, 1, 1))
             ->setResult2($this->getKeyCode($keypad2, 2, 0));

    }

    private function getKeyCode(array $keypad, int $y , int $x): string  {
        $keycode = '';

        foreach(explode("\n", $this->getInput()) as $row) {
            $length = strlen($row);

            for($i=0;$i < $length; $i++) {
                $direction = substr($row, $i, 1);

                switch($direction) {
                    case KEYPAD_UP:
                        if(isset($keypad[$y-1][$x]) && !is_null($keypad[$y-1][$x])) {
                            $y -= 1;
                        }
                        break;
                    case KEYPAD_DOWN:
                        if(isset($keypad[$y+1][$x]) && !is_null($keypad[$y+1][$x])) {
                            $y += 1;
                        }
                        break;
                    case KEYPAD_LEFT:
                        if(isset($keypad[$y][$x-1]) && !is_null($keypad[$y][$x-1])) {
                            $x -= 1;
                        }
                        break;
                    case KEYPAD_RIGHT:
                        if(isset($keypad[$y][$x+1]) && !is_null($keypad[$y][$x+1])) {
                            $x += 1;
                        }
                        break;
                    default:
                        throw new Exception('Invalid direction on keypad');
                }

            }

            $keycode .= $keypad[$y][$x];
        }

        return $keycode;
    }


}