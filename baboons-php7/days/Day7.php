<?php
declare(strict_types=1);

class Day7 {
    use DayTrait;

    public function execute()
    {

        $tls = 0;
        $secret = 0;
        foreach($this->getFile() as $line) {
            $tls += $this->isTLS(trim($line)) ? 1 : 0;
            $secret += $this->isSSL(trim($line)) ? 1 : 0;
        }

        $this->setResult1((string) $tls)
             ->setResult2((string) $secret);

    }

    private function getHypernet(string $line): array
    {
        preg_match_all("/\[(.*?)\]/", $line, $hypernet);
        return end($hypernet);
    }

    private function getSupernet(string $line): array
    {
        return preg_split("/\[.*?\]/", $line);
    }


    private function isTLS(string $line): bool
    {
        $hypernet = $this->getHypernet($line);
        $supernet = $this->getSupernet($line);

        $abba = function(string $string): bool {
            for($i=2; $i < strlen($string); $i++) {
                $a = substr($string, $i-2, 2);
                $b = substr($string, $i, 2);
                if($a == $b) { return false;}
                if($a == strrev($b)) { return true;}
            }
            return false;
        };

        foreach($hypernet as $h) {
            if($abba($h)) return false;
        }

        foreach($supernet as $p) {
            if($abba($p)) return true;
        }

        return false;
    }

    private function isSSL(string $line): bool
    {
        $hypernet = $this->getHypernet($line);
        $supernet = $this->getSupernet($line);

        $aba = function(string $string): array {
            $sequences = [];

            for($i=0; $i < strlen($string); $i++) {
                $sequence = substr($string,$i,3);

                if(strlen($sequence) == 3 &&
                    (substr($sequence,0,1) == substr($sequence,2,1)) &&
                    (substr($sequence,0,1) != substr($sequence,1,1))
                ) {
                    $sequences[] = substr($sequence, 1,1) . substr($sequence, 0,1) . substr($sequence, 1,1);
                }
            }

            return $sequences;
        };

        $strposa = function($haystack, $needle, $offset=0) {
            if(!is_array($needle)) $needle = array($needle);
            foreach($needle as $query) {
                if(strpos($haystack, $query, $offset) !== false) return true;
            }
            return false;
        };

        foreach($supernet as $s) {
            $sequences = $aba($s);
            foreach($hypernet as $h) {
               if($strposa($h, $sequences)) {
                   return true;
               }
            }
        }

        return false;
    }

}