<?php
declare(strict_types=1);

trait DayTrait {

    private $input;
    private $result = [];

    public function __construct()
    {
        $this->input = realpath(__DIR__ . '/../input') . '/' . strtolower(get_class($this)) . '.txt';

        if(!file_exists($this->input)) {
            throw new Exception('Input file missing: ' . $this->input);
        }

        $this->execute();
        $this->printResult();
    }

    private function setResult1(string $value): self
    {
        $this->result[1] = $value;

        return $this;
    }

    private function setResult2(string $value): self
    {
        $this->result[2] = $value;

        return $this;
    }

    public function printResult()
    {
        ksort($this->result);

        foreach($this->result as $part => $value) {
            echo "Part $part: $value" . PHP_EOL;
        }
    }

    private function getInput(): string
    {
        return file_get_contents($this->input);
    }

    private function getFile(): array
    {
        return file($this->input);
    }

    private function getInputFilename()
    {
        return $this->input;
    }

    public function execute() {}

}