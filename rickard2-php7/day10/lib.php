<?php

declare(strict_types = 1);

class Instruction
{
    /**
     * @var string
     */
    private $value;

    public function __construct(string $value)
    {
        $this->value = $value;
    }

    public function isGiveInstruction(): bool
    {
        return strpos($this->value, 'gives') !== false;
    }

    public function isValueInstruction(): bool
    {
        return strpos($this->value, 'value') === 0;
    }

    public function getValueRecipientBotNumber(): int
    {
        preg_match('/goes to bot (\d+)/', $this->value, $matches);

        return intval($matches[1]);
    }

    public function getValue(): int
    {
        preg_match('/value (\d+)/', $this->value, $matches);

        return intval($matches[1]);
    }

    public function getLowRecipientType(): string
    {
        if (strpos($this->value, 'gives low to bot') !== false) {
            return 'bot';
        }

        if (strpos($this->value, 'gives low to output') !== false) {
            return 'output';
        }

        throw new \Exception('Unknown give recipient type');
    }

    public function getHighRecipientType(): string
    {
        if (strpos($this->value, 'and high to bot') !== false) {
            return 'bot';
        }

        if (strpos($this->value, 'and high to output') !== false) {
            return 'output';
        }

        throw new \Exception('Unknown give recipient type');
    }

    public function getGivingBotNumber(): int
    {
        preg_match('/^bot (\d+)/', $this->value, $matches);

        return intval($matches[1]);
    }

    public function getLowRecipientBotNumber(): int
    {
        preg_match('/low to bot (\d+)/', $this->value, $matches);

        return intval($matches[1]);
    }

    public function getHighRecipientBotNumber(): int
    {
        preg_match('/high to bot (\d+)/', $this->value, $matches);

        return intval($matches[1]);
    }

    public function getLowRecipientOutputNumber(): int
    {
        preg_match('/low to output (\d+)/', $this->value, $matches);

        return intval($matches[1]);
    }

    public function getHighRecipientOutputNumber(): int
    {
        preg_match('/high to output (\d+)/', $this->value, $matches);

        return intval($matches[1]);
    }
}

trait NumberedContainerTrait
{
    /**
     * @var int
     */
    private $number;

    public function __construct(int $number)
    {
        $this->number = $number;
    }

    /**
     * @return int
     */
    public function getNumber(): int
    {
        return $this->number;
    }
}

trait ValueContainerTrait
{
    protected $values = [];

    public function addValue(int $value)
    {
        $this->values[] = $value;
    }

    public function containsValue(int $value): bool
    {
        return in_array($value, $this->values);
    }

    public function getValueCount(): int
    {
        return count($this->values);
    }
}

class Bot
{
    use ValueContainerTrait;
    use NumberedContainerTrait;

    /** @var Instruction[] */
    protected $instructions = [];

    /**
     * @return mixed
     */
    public function getLowValue()
    {
        $lowValue = min($this->values);

        unset($this->values[array_search($lowValue, $this->values)]);

        return $lowValue;
    }

    /**
     * @return mixed
     */
    public function getHighValue()
    {
        $highValue = max($this->values);

        unset($this->values[array_search($highValue, $this->values)]);

        return $highValue;
    }

    public function addInstruction(Instruction $instruction)
    {
        $this->instructions[] = $instruction;
    }

    /**
     * @return Instruction[]
     */
    public function getInstructions(): array
    {
        return $this->instructions;
    }
}

class Output
{
    use ValueContainerTrait;
    use NumberedContainerTrait;

    public function getValues()
    {
        return $this->values;
    }
}

class BotRegistry
{
    protected $bots = [];

    public function getBot(int $number): Bot
    {
        if (!isset($this->bots[$number])) {
            $this->bots[$number] = new Bot($number);
        }

        return $this->bots[$number];
    }

    /**
     * @return Bot[]
     */
    public function all(): array
    {
        return $this->bots;
    }

    public function setupInstructions(array $instructions)
    {
        foreach ($instructions as $instruction) {

            if ($instruction->isValueInstruction()) {

                $botNumber = $instruction->getValueRecipientBotNumber();

                $bot = $this->getBot($botNumber);

                $bot->addValue($instruction->getValue());
            } else {
                $bot = $this->getBot($instruction->getGivingBotNumber());

                $bot->addInstruction($instruction);
            }
        }
    }
}

class OutputRegistry
{
    protected $outputs = [];

    public function getOutput(int $number): Output
    {
        if (!isset($this->outputs[$number])) {
            $this->outputs[$number] = new Output($number);
        }

        return $this->outputs[$number];
    }
}

function isCorrectBot(Bot $bot)
{
    return $bot->containsValue(61) && $bot->containsValue(17);
}