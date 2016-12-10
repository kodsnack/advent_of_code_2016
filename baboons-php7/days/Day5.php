<?php
declare(strict_types=1);

class Day5 {
    use DayTrait;

    public function execute()
    {
        $this->setResult1($this->getPassword())
             ->setResult2($this->getPassword(true));
    }

    private function getPassword(bool $byPosition=false): string {
        $i=0;
        $password = [];

        $input = $this->getInput();

        while(count($password) < 8) {

            $hash = md5($input . $i);

            if(substr($hash,0, 5) !== '00000') {
                $i++;
                continue;
            }

            if($byPosition) {
                $position = substr($hash, 5,1);

                if(!isset($password[$position]) && is_numeric($position) && $position < 8) {
                    $password[$position] = substr($hash, 6,1);
                }

            } else {
                $password[] = substr($hash, 5,1);
            }

            $i++;
        }

        ksort($password);

        return implode("", $password);
    }


}