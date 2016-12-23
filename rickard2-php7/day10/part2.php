<?php

require 'lib.php';

$input = file_get_contents(dirname(__FILE__) . '/input');

/** @var Instruction[] $list */
$list = array_map(function ($instruction) {
    return new Instruction($instruction);
}, explode(PHP_EOL, $input));

$botRegistry    = new BotRegistry();
$outputRegistry = new OutputRegistry();

$botRegistry->setupInstructions($list);

function anyBotHasMultipleValues(BotRegistry $botRegistry)
{
    foreach ($botRegistry->all() as $bot) {
        if ($bot->getValueCount() === 2) {
            return true;
        }
    }

    return false;
}

while (anyBotHasMultipleValues($botRegistry)) {
    foreach ($botRegistry->all() as $bot) {
        if ($bot->getValueCount() === 2) {
            $instruction = $bot->getInstructions()[0];

            if ($instruction->getHighRecipientType() === 'output') {
                $highOutput = $outputRegistry->getOutput($instruction->getHighRecipientOutputNumber());

                $highOutput->addValue($bot->getHighValue());
            } else {
                $highBot = $botRegistry->getBot($instruction->getHighRecipientBotNumber());

                $highBot->addValue($bot->getHighValue());
            }

            if ($instruction->getLowRecipientType() === 'output') {
                $lowOutput = $outputRegistry->getOutput($instruction->getLowRecipientOutputNumber());

                $lowOutput->addValue($bot->getLowValue());
            } else {
                $lowBot = $botRegistry->getBot($instruction->getLowRecipientBotNumber());

                $lowBot->addValue($bot->getLowValue());
            }
        }
    }
}

$result = ($outputRegistry->getOutput(0)->getValues()[0]) *
    ($outputRegistry->getOutput(1)->getValues()[0]) *
    ($outputRegistry->getOutput(2)->getValues()[0]);


printf('If i multiply together the values of one chip in each of outputs 0, 1 and 2 I get: %d' . PHP_EOL, $result);