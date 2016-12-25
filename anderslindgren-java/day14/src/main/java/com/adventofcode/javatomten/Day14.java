package com.adventofcode.javatomten;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * Advent of Code 2016-12-14.
 */
public class Day14 {


    private int matches;
    private int finalId;


    class LimitedQueue<E> extends LinkedList<E> {

        private int limit;

        LimitedQueue(int limit) {
            this.limit = limit;
        }

        @Override
        public boolean add(E o) {
            boolean added = super.add(o);
            while (added && size() > limit) {
                super.remove();
            }
            return added;
        }
    }

    class HashId {
        final int id;
        final String hash;

        HashId(int id, String hash) {
            this.id = id;
            this.hash = hash;
        }

        int getId() {
            return id;
        }

        String getHash() {
            return hash;
        }
    }

    public static void main(String... args) throws IOException, NoSuchAlgorithmException {
        Day14 day = new Day14();
        List<String> lines = day.parseArgs(args);
        day.parse(lines.get(0));
    }


    private List<String> parseArgs(String[] args) throws IOException {
        Path path = FileSystems.getDefault().getPath(args[0]);
        return Files.readAllLines(path);
    }


    private void parse(String data) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        solve(data);
        System.out.println(finalId);
    }

    private void solve(String line) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        final MessageDigest md = MessageDigest.getInstance("MD5");

        final LimitedQueue<HashId> hashes = new LimitedQueue<>(1000);
        for (int i = 0; i < 1000; i++) {
            hashes.add(generateHash(line, md, i));
        }

        final Pattern three = Pattern.compile(".*?(\\S)\\1\\1.*");
        int i = 0;
        while (matches < 64) {
            final HashId hashid = hashes.remove();
            final String hash = hashid.getHash();
            final int id = hashid.getId();
            final Matcher match3 = three.matcher(hash);
            if (match3.matches()) {
                final String trio = match3.group(1);
                final String sb = createStringOfFive(trio);

                for (final HashId lookAhead : hashes) {
                    final String lookAheadHash = lookAhead.getHash();
                    if (lookAheadHash.contains(sb)) {
                        matches++;
                        finalId = id;
                        break;
                    }
                }
            }
            hashes.add(generateHash(line, md, i + 1000));
            i++;
        }
    }

    private String createStringOfFive(String trio) {
        final char[] chars = new char[5];
        Arrays.fill(chars, trio.charAt(0));
        return new String(chars);
    }

    private HashId generateHash(String line, MessageDigest md, int i) throws UnsupportedEncodingException {
        final byte[] digest = md.digest((line + i).getBytes("UTF-8"));

        final StringBuilder sb = new StringBuilder();
        for (final byte aDigest : digest) {
            sb.append(Integer.toHexString((aDigest & 0xFF) | 0x100).substring(1, 3));
        }
        return new HashId(i, sb.toString());
    }

}
