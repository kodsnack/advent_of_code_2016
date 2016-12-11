<?php

class Sequence
{
    /**
     * @var string
     */
    private $value;

    public function __construct(string $value)
    {
        $this->value = $value;
    }

    public function isHypernet() : bool
    {
        return strpos($this->value, '[') !== false;
    }

    public function hasAutonomousBridgeBypassAnnotation() : bool
    {
        $characters = $this->value;
        $length     = strlen($characters);

        for ($i = 0; $i < $length - 3; $i++) {

            if ($characters[$i] !== $characters[$i + 1]) {

                $current = $characters[$i] . $characters[$i + 1];
                $next    = $characters[$i + 2] . $characters[$i + 3];

                if (strrev($current) === $next) {
                    return true;
                }
            }
        }

        return false;
    }

    public function isSupernet()
    {
        return !$this->isHypernet();
    }

    public function getAreaBroadcastAccessors() : array
    {
        $characters = $this->value;
        $length     = strlen($characters);
        $found      = [];

        for ($i = 0; $i < $length - 2; $i++) {

            if ($characters[$i] === $characters[$i + 2] && $characters[$i] !== $characters[$i + 1]) {
                $found[] = $characters[$i] . $characters[$i + 1] . $characters[$i + 2];
            }
        }

        return $found;
    }

    public function hasByteAllocationBlock(string $areaBroadcastAccessor) : bool
    {
        $byteAllocationBlock = $areaBroadcastAccessor[1] . $areaBroadcastAccessor[0] . $areaBroadcastAccessor[1];

        return strpos($this->value, $byteAllocationBlock) !== false;
    }
}

class IpAddress
{
    /**
     * @var string
     */
    private $value;

    public function __construct(string $value)
    {
        $this->value = $value;
    }

    public function supportsTLS() : bool
    {
        /** @var Sequence[] $sequences */
        $sequences = $this->getSequences();

        $nonHypernetABBAFound = false;

        foreach ($sequences as $sequence) {
            if ($sequence->isHypernet() && $sequence->hasAutonomousBridgeBypassAnnotation()) {
                return false;
            }

            if ($sequence->isSupernet() && $sequence->hasAutonomousBridgeBypassAnnotation()) {
                $nonHypernetABBAFound = true;
            }
        }

        return $nonHypernetABBAFound;
    }

    public function supportsSSL() : bool
    {
        /** @var Sequence[] $sequences */
        $sequences = $this->getSequences();

        /** @var Sequence[] $supernetSequences */
        $supernetSequences = array_filter($sequences, function (Sequence $sequence) {
            return $sequence->isSupernet();
        });

        /** @var Sequence[] $hypernetSequences */
        $hypernetSequences = array_filter($sequences, function (Sequence $sequence) {
            return $sequence->isHypernet();
        });

        foreach ($supernetSequences as $supernetSequence) {
            foreach ($supernetSequence->getAreaBroadcastAccessors() as $areaBroadcastAccessor) {
                foreach ($hypernetSequences as $hypernetSequence) {
                    if ($hypernetSequence->hasByteAllocationBlock($areaBroadcastAccessor)) {
                        return true;
                    }
                }
            }
        }

        return false;
    }

    /**
     * @return Sequence[]
     */
    protected function getSequences(): array
    {
        preg_match_all('/(\[?[a-z]+\]?)/', $this->value, $matches);

        /** @var Sequence[] $sequences */
        return array_map(function ($match) {
            return new Sequence($match);
        }, $matches[0]);
    }

    /**
     * @param string $filename
     *
     * @return IpAddress[]
     */
    public static function createFromFile(string $filename) : array
    {
        $rows = explode(PHP_EOL, file_get_contents(dirname(__FILE__) . '/' . $filename));

        return array_map(function ($row) {
            return new self($row);
        }, $rows);
    }
}