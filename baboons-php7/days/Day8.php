<?php
declare(strict_types=1);

class Day8 {
    use DayTrait;

    public function execute()
    {

        $display = new Display(50, 6);

        foreach($this->getFile() as $line) {
            $c = explode(" ", $line);

            switch($c[0]) {
                case "rect":
                    $size = explode("x", $c[1]);
                    $display->writeRect((int) $size[0], (int) $size[1]);
                    break;
                case "rotate":
                    $rotation = "rotate" . ucfirst($c[1]);
                    $position = (int) explode("=",$c[2])[1];
                    $by = (int) $c[4];
                    $display->{$rotation}($position, $by);
                    break;
            }
        }

        $this->setResult1((string) $display->countPixels())
             ->setResult2($display->draw());
    }
}

class Display {

    private $screen = [];
    private $screenHeight = 0;
    private $screenWidth = 0;

    public function __construct(int $width, int $height)
    {
        $this->screenHeight = $height;
        $this->screenWidth = $width;
        $this->screen = array_fill(0, $height, array_fill(0, $width, 0));
    }

    public function writeRect(int $width, int $height)
    {
        for($row=0;$row<$height;$row++) {
            for($col=0;$col<$width;$col++) {
                if(isset($this->screen[$row][$col])) {
                    $this->screen[$row][$col] = 1;
                }
            }
        }
    }

    public function rotateColumn(int $x, int $by) {
        $map = $this->screen;

        for($i=0; $i<count($this->screen); $i++) {
            $this->screen[$i][$x] = 0;
        }

        for($i=0; $i<count($this->screen); $i++) {
            $this->screen[($i+$by) % $this->screenHeight][$x] = $map[$i][$x];
        }

    }

    public function rotateRow(int $y, int $by) {
        $map = $this->screen;

        for($i=0; $i<count($this->screen[$y]); $i++) {
            $this->screen[$y][$i] = 0;
        }

        for($i=0; $i<count($this->screen[$y]); $i++) {
            $this->screen[$y][($i+$by) % $this->screenWidth] = $map[$y][$i];
        }

    }

    public function countPixels(): int
    {
        $pixels = $this->screen;

        foreach($pixels as &$row) {
            $row = array_sum($row);
        }

        return array_sum($pixels);
    }

    public function draw(): string
    {
        $string = PHP_EOL;
        foreach($this->screen as $row) {
            foreach($row as $pixel) {
                $string .= $pixel === 0 ? " " : "X";
            }

            $string .= PHP_EOL;
        }

        return $string;
    }

}