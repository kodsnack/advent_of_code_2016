<?php
declare(strict_types=1);

class Day12 {
    use DayTrait;

    public function execute()
    {
        $commands = $this->getFile();

        $password = $this->execAssembunnyCode($commands, ["a" => 0, "b" => 0, "c" => 0, "d" => 0]);
        $this->setResult1((string) $password["a"]);

        $password = $this->execAssembunnyCode($commands, ["a" => 0, "b" => 0, "c" => 1, "d" => 0]);
        $this->setResult2((string) $password["a"]);
    }

    private function execAssembunnyCode(array $commands, array $result): array
    {
        while(true) {
            $current = current($commands);

            @list($cmd, $x, $y) = explode(" ", trim($current));

            switch($cmd) {
                case "cpy":
                    $result[$y] = isset($result[$x]) ? (int) $result[$x] : (int) $x;
                    break;
                case "inc":
                    $result[$x] += 1;
                    break;
                case "dec":
                    $result[$x] -= 1;
                    break;
                case "jnz":
                    if($test = isset($result[$x]) ? $result[$x] : $x != 0) {
                        for($i=0;$i < abs($y-1); $i++) {
                            if($y > 0) next($commands); else prev($commands);
                        }
                    }
                    break;
            }

            if(!next($commands)) {
                break;
            }
        }

        return $result;
    }


}
