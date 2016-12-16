package com.adventofcode.javatomten;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;


/**
 * Advent of Code 2016-12-11.
 * <p>
 * first state
 * <pre>
 * F4  .  .   .    .   .   .   .    .   .
 * F3  .  .   .    .   .   .   .   PrG PrM
 * F2  .  .   .    .  PlM  .   SM   .   .
 * F1  E  TG  TM  PlG  .   SG  .    .   .
 * </pre>
 *
 * wanted final state
 * <pre>
 * F4  E  TG  TM  PlG PlM  SG  SM  PrG PrM
 * F3  .  .   .    .   .   .   .    .   .
 * F2  .  .   .    .   .   .   .    .   .
 * F1  .  .   .    .   .   .   .    .   .
 * </pre>
 */
public class Day11 {

    class Floor {

        private final int floor;
        private List<Generator> generators = new ArrayList<>();
        private List<Microchip> microchips = new ArrayList<>();

        public Floor(int floor) {
            this.floor = floor;
        }

        public void addGenerator(Generator generator) {
            if (canStoreGenerator(generator)) {
                generators.add(generator);
            }
        }

        public void addMicrochip(Microchip microchip) {
            if (canStoreMicrochip(microchip)) {
                microchips.add(microchip);
            }
        }

        public boolean canStoreGenerator(Generator generator) {
            return microchips.stream()
                    .map(m -> m.isCompatible(generator))
                    .reduce((b1, b2) -> b1 || b2)
                    .orElse(false);
        }

        public boolean canStoreMicrochip(Microchip microchip) {
            return generators.stream()
                    .map(g -> g.isCompatible(microchip))
                    .reduce((b1, b2) -> b1 || b2)
                    .orElse(false);
        }

        public List<Load> getCandidates() {
            List<Load> candidates = new ArrayList<>();
            candidates.addAll(generators.stream()
                    .filter(this::hasMatchingMicrochip)
                    .map(g -> new Pair(g, null))
                    .collect(Collectors.toList()));
            return candidates;
        }

        private boolean hasMatchingMicrochip(Generator g) {
            return microchips.stream()
                    .anyMatch(m -> m.getId().equals(g.getId()));
        }
    }

    class Elevator {
        int floor;
        Load bay1;
        Load bay2;

        public Elevator(int floor) {
            this.floor = floor;
        }

        public void load(Load load) {
            if (canLoadInBay1(load)) {
                bay1 = load;
            }
            else if (canLoadInBay2(load)) {
                bay2 = load;
            }
        }

        public boolean canLoad(Load load) {
            return canLoadInBay1(load) || canLoadInBay2(load);
        }

        private boolean canLoadInBay1(Load load) {
            return bay1 == null
                    && (bay2 == null
                    || load.getClass().equals(bay2.getClass())
                    || load.getId().equals(bay2.getId()));
        }

        private boolean canLoadInBay2(Load load) {
            return bay2 == null
                    && (bay1 == null
                    || load.getClass().equals(bay1.getClass())
                    || load.getId().equals(bay1.getId()));
        }


        public Load[] unload() {
            Load[] load = new Load[] {bay1, bay2};
            bay1 = null;
            bay2 = null;
            return load;
        }

        public boolean canRun() {
            return bay2 != null || bay1 != null;
        }

        public void goUp() {
            if (canRun() && floor < 4) {
                floor++;
            }
        }

        public void goDown() {
            if (canRun() && floor > 1) {
                floor--;
            }
        }

        public int getCurrentFloor() {
            return floor;
        }
    }

    interface Load {

        String getId();
    }

    class Generator implements Load {

        private final String id;

        public Generator(String id) {
            this.id = id;
        }

        public boolean isCompatible(Microchip microchip) {
            return microchip.id.equals(id);
        }

        @Override
        public String getId() {
            return id;
        }
    }

    class Microchip implements Load {

        private final String id;

        Microchip(String id) {
            this.id = id;
        }

        public boolean isCompatible(Generator generator) {
            return generator.id.equals(id);
        }

        @Override
        public String getId() {
            return id;
        }
    }

    class Pair implements Load {
        Generator g;
        Microchip m;

        public Pair(Generator g, Microchip m) {
            this.g = g;
            this.m = m;
        }

        @Override
        public String getId() {
            return g.getId();
        }
    }

    /**
     * <pre>
     * F4  .  .   .    .   .   .   .    .   .
     * F3  .  .   .    .   .   .   .   PrG PrM
     * F2  .  .   .    .  PlM  .   SM   .   .
     * F1  E  TG  TM  PlG  .   SG  .    .   .
     * </pre>
     *
     * @param args
     * @throws IOException
     */
    public static void main(String... args) throws IOException {
        Day11 day = new Day11();
        final Map<Integer, Floor> floors = day.initialize();
        Elevator e = day.getElevator();
        int floorNo = e.getCurrentFloor();
        Floor floor = floors.get(floorNo);
        List<Load> candidates = floor.getCandidates();
    }

    private Elevator getElevator() {
        return new Elevator(1);
    }

    private Map<Integer, Floor> initialize() {
        Floor f1 = new Floor(1);
        f1.addGenerator(new Generator("T"));
        f1.addMicrochip(new Microchip("T"));
        f1.addGenerator(new Generator("Pl"));
        f1.addGenerator(new Generator("S"));
        Floor f2 = new Floor(2);
        f2.addMicrochip(new Microchip("Pl"));
        f2.addMicrochip(new Microchip("S"));
        Floor f3 = new Floor(3);
        f1.addGenerator(new Generator("Pr"));
        f1.addMicrochip(new Microchip("Pr"));
        Floor f4 = new Floor(4);

        Map<Integer, Floor> floors = new HashMap<>();
        floors.put(1, f1);
        floors.put(2, f2);
        floors.put(3, f3);
        floors.put(4, f4);

        return floors;

    }


}
