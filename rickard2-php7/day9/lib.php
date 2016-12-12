<?php


interface Piece
{
    public function compress() : string;

    public function decompress() : string;
}

class Text implements Piece
{
    /**
     * @var string
     */
    private $value;

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
}

class Marker implements Piece
{
    /**
     * @var string
     */
    private $value;
    /**
     * @var int
     */
    private $repetitions;

    public function __construct(string $value, int $repetitions)
    {
        $this->value       = $value;
        $this->repetitions = $repetitions;
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

    private function createMarker() : string
    {
        return sprintf('(%dx%d)', strlen($this->value), $this->repetitions);

    }

    public function getDataLength() : int
    {
        return strlen($this->value);
    }
}

class Parser
{
    /**
     * @var string
     */
    private $data;

    /**
     * @var Piece[]
     */
    private $pieces;

    public function __construct(string $data)
    {
        $this->data   = $data;
        $this->pieces = $this->parse($data);
    }

    private function parse(string $data) : array
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

                        $index += $marker->getMarkerLength() + $marker->getDataLength() - 1;
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

    private function isMarkerStart($character) : bool
    {
        return $character === '(';
    }

    private function isMarkerEnd($character) : bool
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
    private function createTextPiece(string $data, int $index, int $pointer)
    {
        $textLength = $index - $pointer;

        if ($textLength > 0) {
            $text = substr($data, $pointer, $textLength);

            return new Text($text);
        }

        return null;
    }

    /**
     * @param string $data
     * @param int    $markerEndIndex
     * @param int    $index
     *
     * @return Marker
     */
    private function createMarkerPiece(string $data, int $markerEndIndex, int $index) : Marker
    {
        $markerDataLength = $markerEndIndex - $index - 1;
        $markerData       = substr($data, $index + 1, $markerDataLength);
        list($dataLength, $repetitions) = array_map('intval', explode('x', $markerData));

        $markerCharacters = substr($data, $markerEndIndex + 1, $dataLength);

        return new Marker($markerCharacters, $repetitions);
    }
}
