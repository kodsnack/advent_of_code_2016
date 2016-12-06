package se.fredrikbroman.adventofcode16.day3;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URL;

import static java.util.Arrays.sort;

import java.util.Scanner;

public class Day31 {
    public static void main(String[] args) {
        int i = 0;
        try {
            URL path = Day31.class.getResource("input.txt");
            Scanner input = new Scanner(new File(path.getFile()));
            while (input.hasNextLine()) {
                String line = input.nextLine();
                String[] split = line.split("\\s+");

                int[] sides = {0, 0, 0};
                sides[0] = Integer.parseInt(split[1]);
                sides[1] = Integer.parseInt(split[2]);
                sides[2] = Integer.parseInt(split[3]);
                sort(sides);

                if ((sides[0] + sides[1]) > sides[2]) {
                    i++;
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        System.out.print(i);
    }
}
