<?php
declare(strict_types=1);

trait DayTrait {

    private $input;
    private $result = [];

    /**
     * DayTrait constructor.
     * @throws Exception
     */
    public function __construct()
    {
        $this->input = realpath(__DIR__ . '/../input') . '/' . strtolower(get_class($this)) . '.txt';

        if(!file_exists($this->input)) {
            throw new Exception('Input file missing: ' . $this->input);
        }

        $this->execute();
        $this->printResult();
    }

    /**
     * @param string $value
     * @return DayTrait
     */
    private function setResult1(string $value): self
    {
        $this->result[1] = $value;

        return $this;
    }

    /**
     * @param string $value
     * @return DayTrait
     */
    private function setResult2(string $value): self
    {
        $this->result[2] = $value;

        return $this;
    }

    /**
     * Void
     */
    public function printResult()
    {
        ksort($this->result);

        foreach($this->result as $part => $value) {
            echo "Part $part: $value" . PHP_EOL;
        }
    }

    /**
     * @return string
     */
    private function getInput(): string
    {
        return file_get_contents($this->input);
    }

    /**
     * @return array
     */
    private function getFile(): array
    {
        return file($this->input);
    }

    public function execute() {}

}