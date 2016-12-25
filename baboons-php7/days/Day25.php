<?php
declare(strict_types=1);

class Day25 {
    use DayTrait;


    private $num = 0;

    private $out = '';

    public function execute()
    {

        while(true) {
            $this->execAssembunnyCode(["a" => $this->num, "b" => 0, "c" => 0, "d" => 0])['a'];
        }

        $this->setResult1((string) $this->num);


    }

    private function execAssembunnyCode(array $result): array
    {
        $commands = $this->getCommands();

        while(true) {
            $current = current($commands);

            @list($cmd, $x, $y, $z) = explode(" ", trim($current));

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
                    if(!is_numeric($y)) {
                        $y = $result[$y];
                    }
                    if($test = isset($result[$x]) ? $result[$x] : $x != 0) {
                        for($i=0;$i < abs($y-1); $i++) {
                            if($y > 0) next($commands); else prev($commands);
                        }
                    }

                    break;
                case "tgl":

                    $k = key($commands) + $result[$x];
                    if(!isset($commands[$k])) continue;

                    $instruction = explode(" ", trim($commands[$k]));

                    if(count($instruction) == 2) {
                        $new = 'inc';
                        if($instruction[0] == 'inc') {
                            $new = 'dec';
                        }

                        $instruction[0] = $new;
                    } elseif(count($instruction) == 3) {
                        $new = 'jnz';
                        if($instruction[0] == 'jnz') {
                            $new = 'cpy';
                        }

                        $instruction[0] = $new;

                    }

                    $commands[$k] = implode(" ", $instruction);

                    break;
                case 'mul':
                    if (isset($result[$x])) {
                        $a = isset($result[$y]) ? $result[$y] : $y;
                        $b = isset($result[$z]) ? $result[$z] : $z;
                        $result[$x] += $a * $b;
                    }
                    break;
                case 'out';
                    $this->out .= $result[$x];

                    if(strlen($this->out) == 10) {
                        if($this->out == "0101010101") {
                            die('Last one: ' . $this->num . PHP_EOL);
                        } else {
                            $this->num +=1;
                            $this->out = '';
                            break 2;
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

    private function getCommands(): array
    {
        $loop = <<<LOOP
cpy b c
inc a
dec c
jnz c -2
dec d
jnz d -5
LOOP;

        $multiply = <<<MULTIPLY
mul a b d
cpy 0 c
cpy 0 c
cpy 0 c
cpy 0 c
cpy 0 d
MULTIPLY;

        $input = str_replace($loop, $multiply, $this->getInput());
        return array_filter(array_map('trim', explode(PHP_EOL, $input)));
    }

}

