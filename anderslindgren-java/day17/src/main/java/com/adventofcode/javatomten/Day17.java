package com.adventofcode.javatomten;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;


/**
 * Advent of Code 2016-12-17.
 */
public class Day17 {

    private final static int MAX_ROOMS_RIGHT = 4;
    private final static int MAX_ROOMS_DOWN = 4;
    private String shortestPath;

    public enum Direction {
        U, D, R, L
    }

    private class Coordinate {
        final int x;
        final int y;

        Coordinate(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            Coordinate that = (Coordinate) o;
            return x == that.x && y == that.y;
        }

        @Override
        public int hashCode() {
            int result = x;
            result = 31 * result + y;
            return result;
        }

        public String toString() {
            return "[" + x + "," + y + "]";
        }
    }


    class Room {
        private final Coordinate id;
        private final String hash;
        private final String path;

        Room(Coordinate id, String hash, String path) {
            this.id = id;
            this.hash = hash;
            this.path = path;
        }

        Coordinate getId() {
            return id;
        }

        String getPath() {
            return path;
        }

        boolean hasDoorUp() {
            return id.y > 0;
        }

        boolean hasDoorDown() {
            return id.y < MAX_ROOMS_DOWN - 1;
        }

        boolean hasDoorLeft() {
            return id.x > 0;
        }

        boolean hasDoorRight() {
            return id.x < MAX_ROOMS_RIGHT - 1;
        }

        /**
         * Only the first four characters of the hash are used; they represent,
         * respectively, the doors up, down, left, and right from your current
         * position.
         * <p>
         * Any b, c, d, e, or f means that the corresponding door is open;
         * any other character (any number or a) means that the corresponding door
         * is closed and locked.
         *
         * @return list of possible directions to go
         */
        List<Direction> getOpenDoors() {
            final List<Direction> openDoors = new ArrayList<>();
            final String direction = hash.substring(0, 4);
            if (isOpen(direction.charAt(1)) && hasDoorDown()) {
                openDoors.add(Direction.D);
            }
            if (isOpen(direction.charAt(0)) && hasDoorUp()) {
                openDoors.add(Direction.U);
            }
            if (isOpen(direction.charAt(3)) && hasDoorRight()) {
                openDoors.add(Direction.R);
            }
            if (isOpen(direction.charAt(2)) && hasDoorLeft()) {
                openDoors.add(Direction.L);
            }
            return openDoors;
        }

        private boolean isOpen(char c) {
            return c >= 'b' && c<= 'f';
        }

        Coordinate getNeighbour(Direction direction) {
            Coordinate c = null;
            switch (direction) {
                case D:
                    c = new Coordinate(id.x, id.y + 1);
                    break;
                case U:
                    c = new Coordinate(id.x, id.y - 1);
                    break;
                case R:
                    c = new Coordinate(id.x + 1, id.y);
                    break;
                case L:
                    c = new Coordinate(id.x - 1, id.y);
                    break;
            }
            return c;
        }

        @Override
        public String toString() {
            return "Room{" +
                    "id=" + id +
                    ", hash='" + hash + '\'' +
                    ", path='" + path + '\'' +
                    '}';
        }
    }

    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day17 day = new Day17();
        List<String> lines = day.parseArgs(args);
        day.parse(lines.get(0));
    }


    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(String line) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        solve(line);
        System.out.println(shortestPath);
    }

    private void solve(String line) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        final MessageDigest md = MessageDigest.getInstance("MD5");

        final Room room = getRoom(line, md, new Coordinate(0, 0), "");
        extendPath(md, line, room);
    }

    private void extendPath(MessageDigest md, String line, Room room) throws UnsupportedEncodingException {
        final String path = room.getPath();
        final Coordinate id = room.getId();
        if (id.x == 3 && id.y == 3) {
            if (shortestPath == null || path.length() < shortestPath.length()) {
                shortestPath = path;
            }
            return;
        }
        final List<Direction> openDoors = room.getOpenDoors();
        for (final Direction direction : openDoors) {
            final String newPath = path + direction;
            final Coordinate newCoordinate = room.getNeighbour(direction);
            final Room newRoom = getRoom(line, md, newCoordinate, newPath);
            extendPath(md, line, newRoom);
        }
    }

    private Room getRoom(String line, MessageDigest md, Coordinate c, String path) throws UnsupportedEncodingException {
        final byte[] digest = md.digest((line + path).getBytes("UTF-8"));

        final StringBuilder sb = new StringBuilder();
        for (final byte aDigest : digest) {
            sb.append(Integer.toHexString((aDigest & 0xFF) | 0x100).substring(1, 3));
        }
        return new Room(c, sb.toString(), path);
    }

}
