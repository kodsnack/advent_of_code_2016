package se.fredrikbroman.adventofcode16.day7;

import java.io.File;
import java.io.FileNotFoundException;
import java.net.URL;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.regex.*;

public class Day71 {
    public static void main(String[] args) {
    	int count = 0;
        List<String> relevant_lines = new ArrayList<String>();

        try {
            URL path = Day71.class.getResource("input.txt");
            Scanner input = new Scanner(new File(path.getFile()));
            while (input.hasNextLine()) {
				String line = input.nextLine();

				Pattern pattern = Pattern.compile("\\[([a-z0-9]*?)\\]+");
				Matcher matcher = pattern.matcher(line);

                outerloop:
				while (matcher.find()) {
					String s = matcher.group();
					s = s.replace("[", "");
					s = s.replace("]", "");
                    for(int i = 0; i <= s.length() - 4; i++) {
                        String sb = s.substring(i, i + 4);
                        if (isPalindrome(sb)) {
                            if(relevant_lines.contains(line)){
                                relevant_lines.remove(relevant_lines.indexOf(line));
                            }
                            break outerloop;
                        }
                        else {
                            if(! relevant_lines.contains(line)) {
                                relevant_lines.add(0, line);
                            }
                        }
                    }
				}
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        line_loop:
        for(String ss : relevant_lines) {
            String[] ip = ss.split("\\[[a-z0-9]*\\]");
            for(String part : ip) {
                for(int i = 0; i <= part.length() - 4; i++) {
                    String sc = part.substring(i, i + 4);
                    if (isPalindrome(sc)) {
                        count++;
                        continue line_loop;
                    }
                }
            }

        }
        System.out.printf("Count: %d\n", count);
    }

    private static boolean isPalindrome(String s) {
        if(s.length() != 4) return false;
        if (s.charAt(0) == s.charAt(3) && s.charAt(1) == s.charAt(2) && s.charAt(0) != s.charAt(1)) {
            return true;
        }
        else return false;
    }
}
