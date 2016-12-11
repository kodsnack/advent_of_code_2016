<?php

class Move
{
    const DIRECTION_LEFT = 'L';
    const DIRECTION_RIGHT = 'R';

    /** @var string */
    protected $direction;

    /*** @var int */
    protected $length;

    public function __construct(string $move)
    {
        $this->direction = substr($move, 0, 1);
        $this->length    = intval(substr($move, 1));
    }

    public function isLeft() : bool
    {
        return $this->direction === self::DIRECTION_LEFT;
    }

    public function isRight() : bool
    {
        return $this->direction === self::DIRECTION_RIGHT;
    }

    public function getLength(): int
    {
        return $this->length;
    }

    function __toString() : string
    {
        return sprintf('%s%d', $this->direction, $this->getLength());
    }

    public static function createFromString(string $input) : array
    {
        return array_map(function ($move) {
            return new Move($move);
        }, explode(', ', $input));
    }

    public static function createFromFile(string $filename) : array
    {
        return self::createFromString(file_get_contents(dirname(__FILE__) . '/' . $filename));
    }
}

class Direction
{
    const DIRECTION_NORTH = 1;
    const DIRECTION_EAST = 2;
    const DIRECTION_SOUTH = 3;
    const DIRECTION_WEST = 4;

    protected $direction = 1;

    public function rotate(Move $move)
    {
        if ($move->isLeft()) {
            $this->direction--;
        } elseif ($move->isRight()) {
            $this->direction++;
        }

        if ($this->direction === 0) {
            $this->direction = self::DIRECTION_WEST;
        }

        if ($this->direction === 5) {
            $this->direction = self::DIRECTION_NORTH;
        }
    }

    public function isNorth() : bool
    {
        return $this->direction === self::DIRECTION_NORTH;
    }

    public function isSouth() : bool
    {
        return $this->direction === self::DIRECTION_SOUTH;
    }

    public function isWest() : bool
    {
        return $this->direction === self::DIRECTION_WEST;
    }

    public function isEast() : bool
    {
        return $this->direction === self::DIRECTION_EAST;
    }

    function __toString()
    {
        switch ($this->direction) {
            case self::DIRECTION_NORTH:
                return 'N';
            case self::DIRECTION_SOUTH:
                return 'S';
            case self::DIRECTION_WEST:
                return 'W';
            case self::DIRECTION_EAST:
                return 'E';
        }

        return 'Unknown';
    }
}

class Position
{
    protected $x = 0;
    protected $y = 0;

    /**
     * @param Direction $direction
     * @param Move      $move
     *
     * @return Position[]
     */
    public function move(Direction $direction, Move $move) : array
    {
        $steps = [];

        for ($count = 0; $count < $move->getLength(); $count++) {

            if ($direction->isNorth()) {
                $this->y += 1;
            }

            if ($direction->isEast()) {
                $this->x += 1;
            }

            if ($direction->isSouth()) {
                $this->y -= 1;
            }

            if ($direction->isWest()) {
                $this->x -= 1;
            }

            $steps[] = clone $this;
        }

        return $steps;
    }

    public function getOffset() : int
    {
        return abs($this->x) + abs($this->y);
    }

    function __toString() : string
    {
        return sprintf('(%d, %d)', $this->x, $this->y);
    }
}
