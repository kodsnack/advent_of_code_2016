<?php

interface Piece
{
    public function compress() : string;

    public function decompress() : string;

    public function __toString() : string;

    public function getDecompressedLength() : int;
}

class Text implements Piece
{
    /**
     * @var string
     */
    protected $value;

    public function __construct(string $value)
    {
        $this->value = $value;
    }

    public function compress() : string
    {
        return $this->value;
    }

    public function decompress() : string
    {
        return $this->value;
    }

    public function __toString(): string
    {
        return $this->decompress();
    }

    public function getDecompressedLength() : int
    {
        return strlen($this->decompress());
    }
}

class Marker implements Piece
{
    /**
     * @var string|Pieces
     */
    protected $value;

    /**
     * @var int
     */
    protected $repetitions;

    /**
     * @var int
     */
    protected $dataLength;

    /**
     * Marker constructor.
     *
     * @param string|Piece $value
     * @param int          $repetitions
     * @param int          $dataLength
     */
    public function __construct($value, int $repetitions, int $dataLength)
    {
        $this->value       = $value;
        $this->repetitions = $repetitions;
        $this->dataLength  = $dataLength;
    }

    public function decompress() : string
    {
        return str_repeat($this->value, $this->repetitions);
    }

    public function compress() : string
    {
        return sprintf('%s%s', $this->createMarker(), $this->value);
    }

    public function getMarkerLength() : int
    {
        return strlen($this->createMarker());
    }

    protected function createMarker() : string
    {
        return sprintf('(%dx%d)', $this->getDataLength(), $this->repetitions);
    }

    public function getDataLength() : int
    {
        return $this->dataLength;
    }

    public function __toString(): string
    {
        return $this->decompress();
    }

    public function getRepetitions() : int
    {
        return $this->repetitions;
    }

    public function getDecompressedLength() : int
    {
        if ($this->value instanceof Pieces) {
            return $this->value->getDecompressedLength() * $this->repetitions;
        }

        return strlen($this->value) * $this->repetitions;
    }
}

class Pieces implements Piece
{
    /**
     * @var array
     */
    private $pieces;

    /**
     * Pieces constructor.
     *
     * @param Piece[] $pieces
     */
    public function __construct(array $pieces)
    {
        $this->pieces = $pieces;
    }

    public function compress() : string
    {
        return join('', array_map(function (Piece $piece) {
            return $piece->compress();
        }, $this->pieces));
    }

    public function decompress() : string
    {
        return join('', array_map(function (Piece $piece) {
            return $piece->decompress();
        }, $this->pieces));
    }

    public function __toString(): string
    {
        return $this->decompress();
    }

    public function getDecompressedLength() : int
    {
        $length = 0;

        foreach ($this->pieces as $piece) {
            $length += $piece->getDecompressedLength();
        }

        return $length;
    }
}

abstract class Parser
{
    /**
     * @var string
     */
    protected $data;

    /**
     * @var Piece[]
     */
    protected $pieces;

    public function __construct(string $data)
    {
        $this->data   = $data;
        $this->pieces = $this->parse($data);
    }

    protected function parse(string $data) : array
    {
        $pieces = [];

        $dataLength = strlen($data);
        $pointer    = 0;

        for ($index = 0; $index < $dataLength; $index++) {

            $character = $data[$index];

            if ($this->isMarkerStart($character)) {

                $textPiece = $this->createTextPiece($data, $index, $pointer);

                if ($textPiece) {
                    $pieces[] = $textPiece;
                }

                for ($markerEndIndex = $index; $markerEndIndex < $dataLength; $markerEndIndex++) {
                    $markerEndCharacter = $data[$markerEndIndex];

                    if ($this->isMarkerEnd($markerEndCharacter)) {

                        $marker = $this->createMarkerPiece($data, $markerEndIndex, $index);

                        $pieces[] = $marker;

                        if ($marker->getRepetitions() === 7) {
                            echo '';
                        }

                        $index += $this->getNextIndex($marker);
                        $pointer = $index + 1;

                        break;
                    }
                }
            }
        }

        $textPiece = $this->createTextPiece($data, $index, $pointer);

        if ($textPiece) {
            $pieces[] = $textPiece;
        }

        return $pieces;
    }

    function __toString() : string
    {
        return join('', $this->pieces);
    }

    protected function isMarkerStart($character) : bool
    {
        return $character === '(';
    }

    protected function isMarkerEnd($character) : bool
    {
        return $character === ')';
    }

    /**
     * @return Piece[]
     */
    public function getPieces(): array
    {
        return $this->pieces;
    }

    /**
     * @param string $data
     * @param int    $index
     * @param int    $pointer
     *
     * @return Text|null
     */
    protected function createTextPiece(string $data, int $index, int $pointer)
    {
        $textLength = $index - $pointer;

        if ($textLength > 0) {
            $text = substr($data, $pointer, $textLength);

            return new Text($text);
        }

        return null;
    }

    abstract protected function createMarkerPiece(string $data, int $markerEndIndex, int $index) : Marker;

    /**
     * @param Marker $marker
     *
     * @return int
     */
    abstract protected function getNextIndex(Marker $marker):int;
}

class Parser1 extends Parser
{
    /**
     * @param string $data
     * @param int    $markerEndIndex
     * @param int    $index
     *
     * @return Marker
     */
    protected function createMarkerPiece(string $data, int $markerEndIndex, int $index) : Marker
    {
        $markerDataLength = $markerEndIndex - $index - 1;
        $markerData       = substr($data, $index + 1, $markerDataLength);
        list($dataLength, $repetitions) = array_map('intval', explode('x', $markerData));

        $markerCharacters = substr($data, $markerEndIndex + 1, $dataLength);

        return new Marker($markerCharacters, $repetitions, $dataLength);
    }

    /**
     * @param Marker $marker
     *
     * @return int
     */
    protected function getNextIndex(Marker $marker):int
    {
        return $marker->getMarkerLength() + $marker->getDataLength() - 1;
    }
}

class Parser2 extends Parser
{
    /**
     * @param string $data
     * @param int    $markerEndIndex
     * @param int    $index
     *
     * @return Marker
     */
    protected function createMarkerPiece(string $data, int $markerEndIndex, int $index) : Marker
    {
        $markerDataLength = $markerEndIndex - $index - 1;
        $markerData       = substr($data, $index + 1, $markerDataLength);
        list($dataLength, $repetitions) = array_map('intval', explode('x', $markerData));

        $markerCharacters = substr($data, $markerEndIndex + 1, $dataLength);

        if ($this->isMarkerStart($markerCharacters[0])) {

            $parser = new Parser2($markerCharacters);

            $pieces = $parser->getPieces();

            return new Marker(new Pieces($pieces), $repetitions, $dataLength);
        }

        return new Marker($markerCharacters, $repetitions, $dataLength);
    }

    /**
     * @param Marker $marker
     *
     * @return int
     */
    protected function getNextIndex(Marker $marker):int
    {
        return $marker->getMarkerLength() + $marker->getDataLength() - 1;
    }
}
