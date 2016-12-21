<?php

class RTG
{
    private $startArrangement;
    public $steps;

    public function __construct($rows, $extras = [])
    {
        $this->startArrangement = $this->inputParser($rows, $extras);

        if (count($extras) > 0) {

        }
    }

    public function addInputComponents()
    {
        $this->startArrangement[1] = array_merge($this->startArrangement[1], ['EL-G', 'EL-M', 'DI-G', 'DI-M']);
    }

    private function inputParser($lines)
    {
        $arrangement = [];
        $floor = 1;
        foreach ($lines as $line) {
            $arrangement[$floor]['elevator'] = ($floor === 1);
            preg_match_all('/ a (.*?) (generator|microchip)/', $line, $matches);
            for ($i = 0; $i < sizeof($matches[1]); $i++) {
                $arrangement[$floor][] = strtoupper(substr($matches[1][$i], 0, 2)) . '-' . strtoupper(substr($matches[2][$i], 0, 1));
            }
            $floor++;
        }
        return $arrangement;
    }

    public function solution()
    {
        $queue = new SplQueue();
        $queue->enqueue([$this->startArrangement, 0]);
        $visited[$this->getKey($this->startArrangement)] = true;
        while ($queue->count() > 0) {
            list($state, $steps) = $queue->dequeue();
            if ($this->isArrangementDone($state)) {
                $this->steps = $steps;
                return true;
            }
            foreach ($this->newArrangements($state) as $nextState) {
                if (isset($visited[$this->getKey($nextState)]) === false) {
                    $visited[$this->getKey($nextState)] = true;
                    $queue->enqueue([$nextState, $steps + 1]);
                }
            }
        }
        return false;
    }

    private function printState($state)
    {
        $stateCopy = $state;
        krsort($stateCopy);
        foreach ($stateCopy as $floor => $floorContent) {
            sort($floorContent);
            echo $floor . ':  ' . implode('   ', $floorContent) . PHP_EOL;
        }
    }

    private function getKey($arrangement)
    {
        $tmp = [];
        ksort($arrangement);
        foreach ($arrangement as $floor => $parts) {
            $elevator = $parts['elevator'];
            unset($parts['elevator']);
            sort($parts);
            $tmp[$floor] = ($elevator === true) ? 1 : 0;
            $tmp[$floor] .= ',';
            $tmp[$floor] .= implode(',', $parts);
        }
        return sha1(implode('|', $tmp));
    }

    private function newArrangements($arrangement)
    {
        $newValidStates = [];
        foreach ($arrangement as $floor => $state) {
            if ($state['elevator'] == true) {
                $elevatorCombos = $this->getCombinations($state);
                foreach ($elevatorCombos as $elevatorCombination) {
                    if ($floor < 4) {
                        $newState = $this->moveItems($arrangement, $elevatorCombination, $floor, $floor + 1);
                        if ($this->isPossibleArrangement($newState)) {
                            $newValidStates[] = $newState;
                        }
                    }
                    if ($floor > 1) {
                        $newState = $this->moveItems($arrangement, $elevatorCombination, $floor, $floor - 1);
                        if ($this->isPossibleArrangement($newState)) {
                            $newValidStates[] = $newState;
                        }
                    }
                }
            }
        }
        return $newValidStates;
    }

    private function moveItems($state, $itemsToMove, $fromFloor, $toFloor)
    {
        $newState = $state;
        $newState[$fromFloor] = array_filter($newState[$fromFloor], function ($var) use ($itemsToMove) {
            return !in_array($var, $itemsToMove);
        });
        $newState[$toFloor] = array_merge($newState[$toFloor], $itemsToMove);
        $newState[$toFloor]['elevator'] = true;
        $newState[$fromFloor]['elevator'] = false;

        return $newState;
    }

    private function isPossibleArrangement($arrangement)
    {
        foreach ($arrangement as $floor) {
            $generators = [];
            $microchips = [];
            foreach ($floor as $item) {
                if ($item[strlen($item) - 1] === 'G')
                    $generators[] = substr($item, 0, -2);
                elseif ($item[strlen($item) - 1] === 'M')
                    $microchips[] = substr($item, 0, -2);
            }
            foreach ($microchips as $microchip) {
                if (count($generators) > 0 && in_array($microchip, $generators) === false)
                    return false;
            }
        }
        return true;
    }

    private function isArrangementDone($arrangement)
    {
        return (
            $arrangement[4]['elevator'] === true &&
            $arrangement[3]['elevator'] === false &&
            $arrangement[2]['elevator'] === false &&
            $arrangement[1]['elevator'] === false &&
            count($arrangement[4]) > 0 &&
            count($arrangement[3]) == 1 &&
            count($arrangement[2]) == 1 &&
            count($arrangement[1]) == 1);
    }

    private function getCombinations($arrangement)
    {
        unset($arrangement['elevator']);
        $results = [[]];
        foreach ($arrangement as $state) {
            foreach ($results as $combination) {
                $results[] = array_merge(array($state), $combination);
            }
        }
        foreach ($results as $key => $set) {
            $size = count($set);
            if ($size < 1 || $size > 2)
                unset($results[$key]);
        }

        return $results;
    }

    function setVisited($arrangement, $visitedArrangement)
    {
        $key = $this->getKey($arrangement);
        $visitedArrangement[$key] = true;

        return $visitedArrangement;
    }
}
