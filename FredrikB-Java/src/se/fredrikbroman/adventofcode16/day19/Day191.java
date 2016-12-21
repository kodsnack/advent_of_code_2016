package se.fredrikbroman.adventofcode16.day19;

// Look at this: https://www.youtube.com/watch?v=uCsD3ZGzMgE

public class Day191 {
    public static void main(String[] args) {
        int elfs = 3018458;
        String rotated = Integer.toBinaryString(elfs);
        char first = rotated.charAt(0);
        rotated = rotated.substring(1);
        rotated = rotated + first;
        System.out.println(Integer.parseInt(rotated, 2));
    }
}
