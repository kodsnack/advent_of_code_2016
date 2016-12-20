<?php
declare(strict_types=1);

define('MAX_IP', 4294967295);

class Day20 {
    use DayTrait;

    public function execute()
    {

        $blockedRanges = $this->getBlockedIPs();
        $openIPs = MAX_IP;

        foreach ($blockedRanges as $range) {
            list($low, $high) = $range;
            $openIPs = $openIPs - ($high - $low + 1);
        }

        $this->setResult1((string) ($blockedRanges[0][1] + 1))
             ->setResult2((string) ($openIPs + 1));
    }

    function getIPs(): array {
        $lines = $this->getFile();
        $IPs = [];

        foreach($lines as $range) {
            $IPs[] = explode('-', trim($range));
        }

        usort($IPs, function ($a, $b) {
            if ($a[0] == $b[0]) return 0;
            return $a[0] < $b[0] ? -1 : 1;
        });

        return $IPs;
    }

    private function getBlockedIPs(): array {
        $input = $this->getIPs();
        $blocked = [];

        foreach($input as $range) {
            $found = false;

            foreach ($blocked as &$blockedRange) {
                if($range[0] >= $blockedRange[0] && $range[0] <= $blockedRange[1] + 1) {
                    $found = true;
                    $blockedRange[1] = max($blockedRange[1], $range[1]);
                } elseif ($range[1] >= $blockedRange[0] - 1 && $range[1] <= $blockedRange[1]) {
                    $found = true;
                    $blockedRange[0] = min($blockedRange[0], $range[0]);
                }
            }

            if(!$found) $blocked[] = $range;
        }

        return $blocked;
    }

}

