<?php
declare(strict_types=1);

define('ROTATE_LEFT', 'L');
define('ROTATE_RIGHT', 'R');

class Day1 {
    use DayTrait;

    public function execute()
    {

        $x = $y = 0;
        $r = 2;
        $locations = [];

        $steps = $this->getInput();

        foreach(array_map('trim',explode(',', $steps)) as $move) {

            $direction = substr($move, 0, 1);
            $distance = (int) substr($move,1);

            if($direction === ROTATE_LEFT) {
                $r = $r === 0 ? 3 : $r-1;
            } elseif($direction === ROTATE_RIGHT) {
                $r = $r === 3 ? 0 : $r+1;
            }

            for($i=0; $i < $distance; $i++) {
                $y += $r === 0 ? 1 : 0; // north
                $y -= $r === 2 ? 1 : 0; // south
                $x -= $r === 1 ? 1 : 0; // west
                $x += $r === 3 ? 1 : 0; // east

                $cordinate = md5($x . $y);

                if(isset($locations[$cordinate])) {
                    $locations[$cordinate]->num++;
                } else {
                    $locations[$cordinate] = (object) [
                        'x'     => $x,
                        'y'     => $y,
                        'num'   => 1
                    ];
                }
            }
        }

        $this->setResult1((string) (abs($x) + abs($y)));

        foreach($locations as $location) {
            if($location->num === 2) {
                $this->setResult2((string) (abs($location->x) + abs($location->y)));
                break;
            }
        }

    }

}