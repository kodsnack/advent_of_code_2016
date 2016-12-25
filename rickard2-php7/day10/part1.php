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

while (true) {
    foreach ($botRegistry->all() as $bot) {
        if ($bot->getValueCount() === 2) {

            if ($bot->containsValue(61) && $bot->containsValue(17)) {
                printf('The number of the bot responsible for comparing value-61 microchips with value-17 microchips is: %d' . PHP_EOL, $bot->getNumber());
                exit();
            }

            $instruction = $bot->getInstructions()[0];

            $lowBot  = $botRegistry->getBot($instruction->getLowRecipientBotNumber());
            $highBot = $botRegistry->getBot($instruction->getHighRecipientBotNumber());

            $lowBot->addValue($bot->getLowValue());
            $highBot->addValue($bot->getHighValue());
        }
    }
}