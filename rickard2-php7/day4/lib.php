<?php

class Room
{
    /**
     * @var string
     */
    private $name;
    /**
     * @var int
     */
    private $sectorId;
    /**
     * @var string
     */
    private $checksum;

    public function __construct(string $name, int $sectorId, string $checksum)
    {
        $this->name     = $name;
        $this->sectorId = $sectorId;
        $this->checksum = $checksum;
    }

    public function isReal()
    {
        return ($this->createChecksum() === $this->checksum);
    }

    /**
     * @param string $filename
     *
     * @return Room[]
     */
    public static function createFromFile(string $filename) : array
    {
        $input = file_get_contents(dirname(__FILE__) . '/' . $filename);
        return array_map(function ($row) {

            preg_match('/([a-z-]+)([0-9]+)\[([a-z]+)\]/', $row, $matches);

            $name     = $matches[1];
            $sectorId = intval($matches[2]);
            $checksum = $matches[3];
            return new self($name, $sectorId, $checksum);

        }, explode(PHP_EOL, $input));
    }

    private function createChecksum() : string
    {
        $nameWithoutDashes = str_replace('-', '', $this->name);

        $length     = strlen($nameWithoutDashes);
        $characters = [];
        $counts     = [];

        for ($i = 0; $i < $length; $i++) {

            $character = $nameWithoutDashes[$i];

            if (!isset($characters[$character])) {
                $characters[$character] = 0;
            }

            $characters[$character]++;
        }

        foreach ($characters as $character => $count) {
            if (!isset($counts[$count])) {
                $counts[$count] = [];
            }

            $counts[$count][] = $character;
        }

        krsort($counts);

        $checksum = [];

        foreach ($counts as $count => $characters) {
            sort($characters);

            foreach ($characters as $character) {

                $checksum[] = $character;

                if (count($checksum) === 5) {
                    return join('', $checksum);
                }
            }
        }

        throw new \Exception('Epic fail');
    }

    /**
     * @return int
     */
    public function getSectorId(): int
    {
        return $this->sectorId;
    }

    public function getName() : string
    {
        return $this->decrypt($this->name);
    }

    private function decrypt(string $name) : string
    {
        $length    = strlen($name);
        $decrypted = '';

        for ($i = 0; $i < $length; $i++) {

            if ($name[$i] === '-') {
                $decrypted .= ' ';
            } else {
                $asciiNumber    = ord($name[$i]);
                $alphabetNumber = $asciiNumber - 96;

                $decryptedAlphabetNumber = ($alphabetNumber + $this->getSectorId()) % 26;
                $decryptedAsciiNumber    = $decryptedAlphabetNumber + 96;
                $decryptedCharacter      = chr($decryptedAsciiNumber);

                $decrypted .= $decryptedCharacter;
            }
        }

        return trim($decrypted);
    }
}