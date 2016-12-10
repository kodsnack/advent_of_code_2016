<?php
declare(strict_types=1);


class Day9 {
    use DayTrait;

    public function execute()
    {
        $this->setResult1((string) $this->getDecompressedSize($this->getInput(), false))
             ->setResult2((string) $this->getDecompressedSize($this->getInput(), true));
    }

    private function getDecompressedSize(string $data, $recursive = false): int
    {
        $handle = fopen('data://text/plain,' . $data, "r");

        $size = 0;
        $marker = false;
        while(!feof($handle)) {
            $char = fread($handle, 1);
            switch(true) {
                case $char == "(":
                    $marker = "";
                    break;
                case $char == ")":
                    list($length, $repeat) = explode("x", $marker);
                    $string = fread($handle, (int) $length);

                    if($recursive) {
                        $size += $this->getDecompressedSize($string, $recursive) * $repeat;
                    } else {
                        $size += $length * $repeat;
                    }

                    $marker = false;
                    break;
                case ($marker !== false):
                    $marker .= $char;
                    break;
                case empty($char):
                    break;
                default:
                    $size += 1;
                    break;
            }
        }

        return $size;
    }

}
