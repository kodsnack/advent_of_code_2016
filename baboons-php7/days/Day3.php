<?php
declare(strict_types=1);

class Day3 {
    use DayTrait;

    public function execute()
    {
        $input = array_map("rtrim", $this->getFile());
        $validTriangles1 = 0;
        $validTriangles2 = 0;

        foreach($input as $row) {
            $triangle = array_map("trim", str_split($row, 5));

            if($this->validateTriangle($triangle))
                $validTriangles1 += 1;
        }

        $this->setResult1((string) $validTriangles1);

        for($i=0;$i<count($input);$i+=3) {

            for($j=0;$j<3;$j++) {
                $triangle = [
                    str_split($input[$i],   5)[$j],
                    str_split($input[$i+1], 5)[$j],
                    str_split($input[$i+2], 5)[$j]
                ];

                if($this->validateTriangle($triangle))
                    $validTriangles2 += 1;
            }
        }

        $this->setResult2((string) $validTriangles2);
    }

    private function validateTriangle(array $triangle): bool {
        sort($triangle);
        return $triangle[0] + $triangle[1] > $triangle[2];
    }

}