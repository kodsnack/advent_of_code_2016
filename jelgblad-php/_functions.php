<?php

function print_info($day){

    // Print some info
    echo "Advent of Code 2016 Day " . $day . "\nphp solution by jelgblad\n\n";
}

function read_input($day){
    
    // Open input file
    $input_file = fopen("./input/day" . $day, "r") or die("Unable to open file!");

    // Read input file contents
    $input_contents = fread($input_file, filesize("./input/day" . $day));

    // Close input file
    fclose($input_file);

    return $input_contents;
}

function print_solution($solution){

    // Print solution
    echo "The answer is: " . $solution;
}