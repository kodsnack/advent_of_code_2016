package com.adventofcode.javatomten;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static java.lang.Integer.parseInt;


/**
 * Advent of Code 2016-12-07.
 */
public class Day8 {


    public static final String RECT = "rect ";
    public static final String ROTATE_COLUMN = "rotate column ";
    public static final String ROTATE_ROW = "rotate row ";

    interface Instruction {
        void apply(Display display);
    }

    class Rect implements Instruction {

        private final int x;
        private final int y;

        Rect(int x, int y) {
            System.out.printf("RECT [%d,%d]\n", x, y);
            this.x = x;
            this.y = y;
        }

        @Override
        public void apply(Display display) {
            for (int row = 0; row < y; row++) {
                for (int col = 0; col < x; col++) {
                    display.matrix[row][col] = 1;
                }
            }
        }
    }

    class RotateColumn implements Instruction {

        private final int column;
        private final int by;

        public RotateColumn(int column, int by) {
            System.out.printf("ROT COL [%d by %d]\n", column, by);
            this.column = column;
            this.by = by;
        }

        @Override
        public void apply(Display display) {
            List<Short> c = new ArrayList<>();
            for (int i = 0; i < display.rows; i++) {
                c.add(display.matrix[i][column]);
            }
            Collections.rotate(c, by);
            for (int i = 0; i < display.rows; i++) {
                display.matrix[i][column] = c.get(i);
            }
        }
    }

    class RotateRow implements Instruction {

        private final int row;
        private final int by;

        public RotateRow(int row, int by) {
            System.out.printf("ROT ROW [%d by %d]\n", row, by);

            this.row = row;
            this.by = by;
        }

        @Override
        public void apply(Display display) {
            List<Short> c = new ArrayList<>();
            for (int i = 0; i < display.columns; i++) {
                c.add(display.matrix[row][i]);
            }
            Collections.rotate(c, by);
            for (int i = 0; i < display.columns; i++) {
                display.matrix[row][i] = c.get(i);
            }

        }
    }

    private class Display {

        private final int columns;
        private final int rows;
        short[][] matrix;

        public Display(int columns, int rows) {
            this.columns = columns;
            this.rows = rows;
            matrix = new short[rows][columns];
        }

        public void apply(Instruction instruction) {
            instruction.apply(this);
        }

        public int output() {
            int i = 0;

            for (short[] row : matrix) {
                for (short pixel : row) {
                    i += pixel;
                }
            }

            return i;
        }

        public String toString() {
            StringBuilder sb = new StringBuilder();
            for (short[] row : matrix) {
                for (short pixel : row) {
                    if (pixel == 1) {
                        sb.append("#");
                    }
                    else {
                        sb.append(" ");
                    }
                }
                sb.append("\n");
            }

            return sb.toString();
        }

    }


    public static void main(String... args) throws IOException {
        Day8 day = new Day8();
        List<String> lines = day.parseArgs(args);
        day.parse(lines);
    }

    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }

    private void parse(List<String> instructions) {
        Display display = new Display(50, 6);
        //Display display = new Display(7, 3);
        System.out.println(display.toString());
        System.out.println("----");
        for (final String instString : instructions) {
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            Instruction inst = build(instString);
            display.apply(inst);
            System.out.println(display.toString());
            System.out.println("----");
        }
        System.out.println(display.output());
    }

    Instruction build(String instrString) {
        // rect AxB
        if (instrString.startsWith(RECT)) {
            final String xAndY = instrString.substring(RECT.length());
            final String[] sizes = xAndY.split("x");
            final int x = parseInt(sizes[0]);
            final int y = parseInt(sizes[1]);
            return new Rect(x, y);
        }
        // rotate column x=1 by 1
        else if (instrString.startsWith(ROTATE_COLUMN)) {
            final String columnAndBy = instrString.substring(ROTATE_COLUMN.length() + 2);
            final String[] colAndAmount = columnAndBy.replace(" by ", ",").split(",");
            final int column = parseInt(colAndAmount[0]);
            final int by = parseInt(colAndAmount[1]);
            return new RotateColumn(column, by);
        }
        // rotate row y=1 by 1
        else if (instrString.startsWith(ROTATE_ROW)) {
            final String rowAndBy = instrString.substring(ROTATE_ROW.length() + 2);
            final String[] rowAndAmount = rowAndBy.replace(" by ", ",").split(",");
            final int row = parseInt(rowAndAmount[0]);
            final int by = parseInt(rowAndAmount[1]);
            return new RotateRow(row, by);
        }
        throw new IllegalArgumentException("Unknown instruction: " + instrString);
    }

}
