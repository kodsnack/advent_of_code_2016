<?php
declare(strict_types=1);


class Day14 {
    use DayTrait;

    public function execute()
    {
        $salt = $this->getInput();

        $this->setResult1((string) $this->solve($salt, 1));
        $this->setResult2((string) $this->solve($salt, 2016));
    }

    private function solve(string $salt, int $num = 1)
    {
        $keys = [];
        $candidates = [];
        $i = 0;

        $getChars = function (int $index) use ($salt, $num): array {
            $hash = md5($salt . $index);

            if($num > 1) {
                for($i=0; $i<$num; $i++) { $hash = md5($hash); }
            }

            preg_match_all( '/(.)\1+/', $hash, $matches );

            $result = [];

            foreach($matches[0] as $chars) {
                $len = strlen($chars);
                if($len > 2) $result[$chars[0]] = strlen($chars);
            }

            return $result;
        };

        while(count($keys) < 64) {
            $chars = $getChars($i);

            if(count($chars) == 0) {
                $i++;
                continue;
            }

            if(count($candidates) > 0) {
                foreach($candidates as $k => $values) {
                    list($start, $triplet) = $values;
                    if($start < $i && ($start + 1000) >= $i) {
                        if(isset($chars[$triplet]) && $chars[$triplet] > 4) {
                            $keys[] = $start;
                        }
                    } else unset($candidates[$k]);
                }
            }

            $candidates[] = [$i, key($chars)];

            $i++;
        }

        return $keys[63];
    }
}

