<?php
declare(strict_types=1);

define('START', [1,1]);
define('END',[31,39]);

class Day13 {
    use DayTrait;

    public function execute()
    {

        $map = new Map((int) $this->getInput());
        $map->find();

        $this->setResult1((string) $map->steps);

        $map = new Map((int) $this->getInput());
        $map->find(50);

        $this->setResult2((string) $map->steps);
    }
}

class Map {

    public $steps = 0;

    private $magic = 0;

    public function __construct(int $magic)
    {
        $this->magic = $magic;

        $this->directions = [
            [1,  0],
            [0,  1],
            [-1, 0],
            [0, -1],
        ];
    }

    public function find(int $maxSteps = 0)
    {
        list($startX, $startY) = START;
        list($endX, $endY) = END;

        $heap = new MapHeap();
        $heap->insert([$startX,$startY,0]);

        $map  = [id($startX,$startY) => [0,0]];

        while(true) {
            if($heap->isEmpty()) {
                throw new \Exception('Could find end!');
            }

            list($x, $y, $steps) = $heap->extract();

            if($maxSteps > 0 && $steps > $maxSteps) {
                foreach($map as $block) {
                    if($block[0] === 0 && $block[1] === 1) {
                        $this->steps += 1;
                    }
                }
                break;
            }

            if($maxSteps == 0) {
                if($x == $endX && $y == $endY) {
                    $this->steps = $steps;
                    break;
                }
            }

            if($map[id($x,$y)][1] == 1) {
                continue;
            }

            $map[id($x,$y)][1] = 1;
            $steps += 1;

            foreach($this->directions as $direction) {
                $dirX = $x + $direction[0];
                $dirY = $y + $direction[1];
                $id = id($dirX, $dirY);

                if($dirX >= 0 && $dirY >= 0 && array_key_exists($id, $map) === false) {
                    $wall = $this->wall([$dirX, $dirY]);
                    $map[$id] = [$wall,0];
                    if(!$wall) {
                        $heap->insert([$dirX,$dirY,$steps]);
                    }
                }

            }
        }
    }

    private function wall(array $position): int {
        list($x, $y) = $position;
        $bin = decbin(($x*$x + 3*$x + 2*$x*$y + $y + $y*$y + $this->magic));

        return substr_count($bin, '1') % 2;
    }
}

class MapHeap extends SplHeap {

    public function compare(array $pos1, array $pos2): int
    {
        if ($pos1[2] === $pos2[2]) return 0;
        return $pos1[2] > $pos2[2] ? -1 : 1;
    }

}

function id($x, $y): string
{
    return "x" . $x . "y" . $y;
}
