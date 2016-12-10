<?php
declare(strict_types=1);


class Day9 {
    use DayTrait;

    public function execute()
    {
        /*
        var_dump(filesize($this->decompress($this->getInputFilename(), false)));
        var_dump(filesize($this->decompress($this->getInputFilename(), true)));
        */
    }

    private function decompress(string $filename, bool $continue = false): string
    {
        $decompressedFilename = "/tmp/decompressed";
        $tempFilename = tempnam("/tmp", "");

        $fh = fopen($filename, "r");
        $fd = fopen($tempFilename, "w");

        $marker = false;

        while(!feof($fh)) {
            $c = fread($fh, 1);

            switch(true) {
                case $c == "(":
                    $marker = "";
                    break;
                case $c == ")":
                    list($length, $repeat) = explode("x", $marker);
                    $string = fread($fh, (int) $length);
                    for($i=0; $i<$repeat; $i++) {
                        fwrite($fd, $string, (int) $length);
                    }

                    $marker = false;
                    break;
                case ($marker !== false):
                    $marker .= $c;
                    break;
                default:
                    fwrite($fd, $c, 1);
                    break;
            }
        }

        $readPosition = ftell($fh);
        $writePosition = ftell($fd);

        fclose($fh);
        fclose($fd);

        rename($tempFilename, $decompressedFilename);

        var_dump($continue);
        var_dump($readPosition);
        var_dump($writePosition);
        if($continue && $readPosition !== $writePosition) {
            return $this->decompress($decompressedFilename, true);
        }

        return $decompressedFilename;
    }

}
