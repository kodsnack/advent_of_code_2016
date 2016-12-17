<?php
declare(strict_types=1);

define('START', [0,0]);
define('END',   [3,3]);

class Day17 {
    use DayTrait;

    public function execute()
    {
        $map = new Map($this->getInput());
        $map->solve();

        $this->setResult1((string) $map->path)
             ->setResult2((string) $map->longest);
    }
}

class Map {

    private $passcode;

    public $steps   = 0;
    public $longest = 0;
    public $path    = "";

    public function __construct(string $passcode)
    {
        $this->passcode   = $passcode;
        $this->directions = [
            'R' => [1,  0],
            'D' => [0,  1],
            'L' => [-1, 0],
            'U' => [0, -1],
        ];
    }

    public function solve()
    {
        list($startX, $startY)  = START;
        list($endX, $endY)      = END;

        $heap = new MapHeap();
        $heap->insert([$startX,$startY,0, ""]);

        while(true) {
            if($heap->isEmpty()) break;

            list($x, $y, $steps, $path) = $heap->extract();

            if($x == $endX && $y == $endY) {
                if(empty($this->path)) {
                    $this->path = $path;
                    $this->steps = $steps;
                }
                if($this->longest < $steps) $this->longest = $steps;
                continue;
            }

            $steps += 1;
            $doors = $this->doors($path);

            foreach($this->directions as $direction => $move) {
                if($doors[$direction] == 0) continue;

                $dirX = $x + $move[0];
                $dirY = $y + $move[1];

                if($dirX >= 0 && $dirY >= 0 && $dirX <= 3 && $dirY <= 3) {
                    $heap->insert([$dirX,$dirY,$steps, $path . $direction]);
                }
            }
        }
    }

    private function doors(string $path): array
    {
        $hash = substr(md5($this->passcode . $path),0, 4);
        $doors = array_map(function($v) {
            if(strspn($v, "bcdef")) {
                return 1;
            }

            return 0;
        }, array_combine([0 => 'U', 'D', 'L', 'R'], str_split($hash, 1)));

        return $doors;
    }

}

class MapHeap extends SplHeap {

    public function compare(array $pos1, array $pos2): int
    {
        if ($pos1[2] === $pos2[2]) return 0;
        return $pos1[2] > $pos2[2] ? -1 : 1;
    }

}
