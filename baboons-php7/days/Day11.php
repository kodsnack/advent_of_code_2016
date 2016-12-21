<?php
declare(strict_types=1);

ini_set('memory_limit', '-1');

class Day11 {
    use DayTrait;

    public function execute()
    {

        $input = $this->getFile();

        $puzzle = new Puzzle($input);

        if($puzzle->solve()) {
            $this->setResult1((string) $puzzle->steps);
        }

        $puzzle = new Puzzle($input, ['ELG','ELM','DIG','DIM']);

        if($puzzle->solve()) {
            $this->setResult2((string) $puzzle->steps);
        }

    }

}

class Puzzle {

    private $startState;

    public $steps;

    public function __construct(array $rows, array $extras = [])
    {
        $this->startState = $this->parse($rows, $extras);

        if(count($extras) > 0) {
            $this->startState[1] = array_merge($this->startState[1], $extras);
        }

    }

    public function solve()
    {
        $queue = new SplQueue();
        $queue->enqueue([$this->startState, 0]);

        $visited[$this->hashState($this->startState)] = true;
        while ($queue->count() > 0) {

            list($state, $steps) = $queue->dequeue();

            if ($this->isStateDone($state)) {
                $this->steps = $steps;
                return true;
            }

            foreach ($this->calculateNewValidStates($state) as $nextState) {
                if (isset($visited[$this->hashState($nextState)]) === false) {
                    $visited[$this->hashState($nextState)] = true;
                    $queue->enqueue([$nextState, $steps + 1]);
                }
            }
        }
        return false;
    }

    public function printState($state)
    {
        $stateCopy = $state;
        krsort($stateCopy);
        foreach ($stateCopy as $floor => $floorContent) {
            sort($floorContent);
            echo $floor . ':  ' . implode('   ', $floorContent) . PHP_EOL;
        }
    }

    private function parse(array $rows): array
    {
        $state = [1 => ['E'], 2 => [], 3 => [], 4 => []];
        $floor = 1;
        foreach ($rows as $row) {
            $parts = preg_split('/and|,|\./', $row);
            foreach ($parts as $part) {
                if (preg_match('/(\w*) generator/', $part, $output)) {
                    $state[$floor][] = strtoupper(substr($output[1], 0, 2)) . 'G';
                }
                if (preg_match('/(\w*)-compatible microchip/', $part, $output)) {
                    $state[$floor][] = strtoupper(substr($output[1], 0, 2)) . 'M';
                }
            }
            $floor++;
        }
        return $state;
    }

    private function hashState(array $state): string
    {
        $floors = [];
        foreach ($state as $floor => $floorContent) {
            sort($floorContent);
            $floors[] = $floor . ':' . implode(',', $floorContent);
        }

        return md5(implode('|', $floors));
    }

    private function calculateNewValidStates(array $state): array
    {
        $newValidStates = [];
        foreach ($state as $floorNumber => $floorContent) {
            if (in_array('E', $floorContent)) {
                $elevatorCombos = $this->powerSetOfLengthWithoutElevator($floorContent, 1, 2);
                foreach ($elevatorCombos as $elevatorCombination) {
                    if ($floorNumber < 4) {
                        $newState = $this->moveItems($state, $elevatorCombination, $floorNumber, $floorNumber + 1);
                        if ($this->isSafeState($newState)) {
                            $newValidStates[] = $newState;
                        }
                    }
                    if ($floorNumber > 1) {
                        $newState = $this->moveItems($state, $elevatorCombination, $floorNumber, $floorNumber - 1);
                        if ($this->isSafeState($newState)) {
                            $newValidStates[] = $newState;
                        }
                    }
                }
            }
        }
        return $newValidStates;
    }

    private function moveItems(array $state, array $itemsToMove, int $fromFloor, int $toFloor): array
    {
        $newState = $state;
        $newState[$toFloor] = array_merge($newState[$toFloor], $itemsToMove, ['E']);
        $newState[$fromFloor] = array_filter($newState[$fromFloor], function ($var) use ($itemsToMove) {
            if ($var === 'E') return false;
            return ! in_array($var, $itemsToMove);
        });
        return $newState;
    }

    private function isSafeState(array $state): bool
    {
        foreach ($state as $floorContents) {
            $generators = [];
            $microchips = [];
            foreach ($floorContents as $item) {
                if ($item[strlen($item) - 1] === 'G')
                    $generators[] = substr($item, 0, -1);
                elseif ($item[strlen($item) - 1] === 'M')
                    $microchips[] = substr($item, 0, -1);
            }

            foreach ($microchips as $microchip) {
                if (count($generators) > 0 && in_array($microchip, $generators) === false)
                    return false;
            }
        }
        return true;
    }

    private function isStateDone(array $state): bool
    {
        return count($state[4]) > 0 && count($state[1]) === 0 && count($state[2]) === 0 && count($state[3]) === 0;
    }

    private function powerSetOfLengthWithoutElevator(array $elements, int $min, int $max): array
    {
        $elevatorKey = array_search('E', $elements, true);

        if ($elevatorKey !== false)
            unset($elements[$elevatorKey]);

        $result = $this->powerSet($elements);

        foreach ($result as $key => $set) {
            $size = count($set);
            if ($size < $min || $size > $max)
                unset($result[$key]);
        }
        return $result;
    }


    private function powerSet(array $elements): array
    {
        $results = [[]];
        foreach ($elements as $element) {
            foreach ($results as $combination) {
                array_push($results, array_merge(array($element), $combination));
            }
        }
        return $results;
    }

}