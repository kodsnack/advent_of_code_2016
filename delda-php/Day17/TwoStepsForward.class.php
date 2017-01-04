<?php

class TwoStepsForward
{
    function first($passcode, $position)
    {
        $shortestPathLength = PHP_INT_MAX;
        $shortestPath = '';
        $queue = new SplQueue();
        $queue->enqueue(['', $position]);
        while (!$queue->isEmpty()) {
            list($path, $position) = $queue->dequeue();
            if ($shortestPathLength > strlen($path)) {
                if ($this->isFinalPosition($position)) {
                    $shortestPathLength = strlen($path);
                    $shortestPath = $path;
                    continue;
                }
            } else {
                continue;
            }
            foreach ($this->getNeighborhood($passcode, $path, $position) as $direction => $coordinates) {
                $queue->enqueue([$path.$direction, $coordinates]);
            }
        }

        return $shortestPath;
    }

    function second($passcode, $position)
    {
        $longestPathLength = 0;
        $longestPath = '';
        $queue = new SplQueue();
        $queue->enqueue(['', $position]);
        while (!$queue->isEmpty()) {
            list($path, $position) = $queue->dequeue();
            if ($this->isFinalPosition($position)) {
                if ($longestPathLength < strlen($path)) {
                    $longestPathLength = strlen($path);
                    $longestPath = $path;
                }
                continue;
            }
            foreach ($this->getNeighborhood($passcode, $path, $position) as $direction => $coordinates) {
                $queue->enqueue([$path.$direction, $coordinates]);
            }
        }

        return $longestPath;
    }

    function getNeighborhood($passcode, $path, $position)
    {
        $hash = md5($passcode.$path);
        $result = [];
        if (ord($hash[0]) > 97 && $position['y'] > 0) {
            $result['U'] = ['x' => ($position['x']), 'y' => $position['y']-1];
        }
        if (ord($hash[1]) > 97 && $position['y'] < 3) {
            $result['D'] = ['x' => ($position['x']), 'y' => $position['y']+1];
        }
        if (ord($hash[2]) > 97 && $position['x'] > 0) {
            $result['L'] = ['x' => ($position['x']-1), 'y' => $position['y']];
        }
        if (ord($hash[3]) > 97 && $position['x'] < 3) {
            $result['R'] = ['x' => ($position['x']+1), 'y' => $position['y']];
        }

        return $result;
    }

    function isFinalPosition($coordonates)
    {
        return ($coordonates['x'] == 3 && $coordonates['y'] == 3) ? true : false;
    }
}
