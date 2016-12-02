<?php

// Require common functions
require_once("_functions.php");

// Specify day
$day = 1;

// Print some info
print_info($day);

// Get input
$input = read_input($day);

// Initialize
$direction = 0;
$pos_x = 0;
$pos_y = 0;

// Get new direction
function get_new_direction($turn){

    global $direction;

    if($turn === "L"){

        if($direction === 0)
            return 3;
        else
            return $direction - 1;
    }
    else if($turn === "R"){

        if($direction === 3)
            return 0;
        else
            return $direction + 1;
    }
    else{
        die("Unknown input direction: " . $turn);
    }
}

// Move
function move($dist){

    global $direction, $pos_x, $pos_y;

    switch($direction){
        case 0 :
            $pos_y += $dist;
            break;

        case 1 :
            $pos_x += $dist;
            break;

        case 2 :
            $pos_y -= $dist;
            break;

        case 3 :
            $pos_x -= $dist;
            break;
    }
}

$input_steps = explode(", ", $input);

foreach($input_steps as $step){
    // echo $step . "\n";
    
    $turn = substr($step, 0, 1);
    $dist = substr($step, 1);

    // Set new direction
    $direction = get_new_direction($turn);

    // Move
    move($dist);
}

// Calculate distance from 0,0 in positive numbers
$dist = abs($pos_x) + abs($pos_y); 

print_solution($dist);