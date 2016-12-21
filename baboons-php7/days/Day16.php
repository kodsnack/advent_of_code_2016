<?php
declare(strict_types=1);

class Day16 {
    use DayTrait;

    public function execute()
    {
        $this->setResult1($this->solve(272));
        $this->setResult2($this->solve(35651584));
    }

    private function solve(int $length): string
    {
        $input = $this->getInput();

        while(strlen($input) < $length) {
            $input = $this->fill($input);
        }

        return $this->checksum(substr($input, 0, $length));
    }

    private function fill(string $input): string {
        $end = "";
        for($i=strlen($input)-1;$i>=0;$i--) {
            $end .= substr($input, $i, 1) == 0 ? "1" : "0";

        }
        return $input . "0" . $end;
    }

    private function checksum(string $input): string {
        $checksum = "";

        for($i=0;$i<strlen($input);$i+=2) {
            $pair = substr($input,$i,2);
            $checksum .= $pair[0] == $pair[1] ? 1 : 0;
        }

        if(strlen($checksum) % 2 === 0) return $this->checksum($checksum);
        return $checksum;
    }

}

