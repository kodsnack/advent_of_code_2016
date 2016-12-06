<?php
declare(strict_types=1);

class Day4 {
    use DayTrait;

    public function execute()
    {
        $input = explode("\n", $this->getInput());

        $sectorIdSum = 0;

        foreach($input as $line) {
            preg_match("/^([a-z\-]+)\-(\d+)\[([a-z]+)\]$/", $line, $match);

            $key = str_replace("-", "", $match[1]);
            $sectorId = $match[2];
            $checksum = $match[3];

            if(strstr($this->decrypt($match[1], (int) $sectorId), "northpole")) {
                $this->setResult2($sectorId);
            }

            if($this->getChecksum($key) == $checksum) {
                $sectorIdSum += $sectorId;
            }
        }

        $this->setResult1((string) $sectorIdSum);

    }

    private function decrypt(string $string, int $n): string {
        $crypted = str_split($string);
        $decrypted = "";

        foreach($crypted as $letter) {
            $decrypted .= $this->strRot($letter, $n);
        }

        return str_replace("-", " ", $decrypted);
    }

    private function getChecksum(string $string): string {
        $chars = count_chars($string, 1);
        arsort($chars);

        $arr = [];
        foreach($chars as $char => $i) {

            if(!isset($arr[$i])) {
                $arr[$i] = [];
            }
            $arr[$i][] = chr($char);
        }

        foreach($arr as &$a) {
            sort($a);
            $a = implode("", $a);
        }

        return substr(implode("", $arr),0, 5);
    }

    private function strRot(string $s, int $n): string {
        static $letters = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';

        $n = (int)$n % 26;

        if (!$n) return $s;
        if ($n < 0) $n += 26;
        if ($n == 13) return str_rot13($s);

        $rep = substr($letters, $n * 2) . substr($letters, 0, $n * 2);
        return strtr($s, $letters, $rep);
    }


}