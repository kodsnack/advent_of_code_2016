package se.fredrikbroman.adventofcode16.day6;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URL;

import java.util.Scanner;

public class Day61 {
    public static void main(String[] args) {
        String[] s = {"", "", "", "", "", "", "", ""}; // Ugly, hardcoded array length
        int len = 0;

        try {
            URL path = Day61.class.getResource("input.txt");
            Scanner input = new Scanner(new File(path.getFile()));
            while (input.hasNextLine()) {
                char[] charArray = input.nextLine().toCharArray();
                len = charArray.length;

                for(int i = 0; i < len; i++) {
                    s[i] += charArray[i];
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        for(int i = 0; i < len; i++) {
            System.out.print(highestOccuredChar(s[i]));
        }
    }

    // Shamelessly stolen from Stack overflow. There must be a better way to do this.
    private static char highestOccuredChar(String str) {

        int [] count = new int [256];

        for ( int i=0 ;i<str.length() ; i++){
            count[str.charAt(i)]++;
        }

        int max = -1 ;
        char result = ' ' ;

        for(int j =0 ;j<str.length() ; j++){
            if(max < count[str.charAt(j)] && count[str.charAt(j)] > 1) {
                max = count[str.charAt(j)];
                result = str.charAt(j);
            }
        }

        return result;

    }
}
